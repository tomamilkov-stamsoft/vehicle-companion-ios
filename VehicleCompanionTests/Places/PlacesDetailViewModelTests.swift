import Foundation
import Testing
@testable import VehicleCompanion

private final class SavedPOIRepositoryForDetailTests: SavedPOIRepository {
    var saved: [SavedPOI] = []
    var shouldFailOnToggle = false

    func fetchAll() throws -> [SavedPOI] {
        saved
    }

    func upsert(_ poi: POI) throws {
        if shouldFailOnToggle {
            throw SavedPOIRepositoryError.saveFailed("forced")
        }

        if !saved.contains(where: { $0.id == poi.id }) {
            saved.insert(
                SavedPOI(
                    id: poi.id,
                    name: poi.name,
                    url: poi.url,
                    category: poi.category,
                    rating: poi.rating,
                    imageURL: poi.imageURL,
                    longitude: poi.longitude,
                    latitude: poi.latitude,
                    savedAt: Date()
                ),
                at: 0
            )
        }
    }

    func delete(id: Int) throws {
        if shouldFailOnToggle {
            throw SavedPOIRepositoryError.deleteFailed("forced")
        }

        saved.removeAll(where: { $0.id == id })
    }

    func isSaved(id: Int) throws -> Bool {
        saved.contains(where: { $0.id == id })
    }
}

struct PlacesDetailViewModelTests {
    private var samplePOI: POI {
        POI(
            id: 42,
            name: "Park",
            url: URL(string: "https://example.com"),
            category: "Nature",
            rating: 4,
            imageURL: URL(string: "https://example.com/image.jpg"),
            longitude: -84.5,
            latitude: 39.1
        )
    }

    @Test
    @MainActor
    func initializesWithSavedStateFromRepository() {
        let repository = SavedPOIRepositoryForDetailTests()
        repository.saved = [
            SavedPOI(
                id: samplePOI.id,
                name: samplePOI.name,
                url: samplePOI.url,
                category: samplePOI.category,
                rating: samplePOI.rating,
                imageURL: samplePOI.imageURL,
                longitude: samplePOI.longitude,
                latitude: samplePOI.latitude,
                savedAt: Date()
            )
        ]

        let viewModel = PlacesDetailViewModel(
            poi: samplePOI,
            getSavedPOIsUseCase: GetSavedPOIsUseCaseImpl(repository: repository),
            toggleSavedPOIUseCase: ToggleSavedPOIUseCaseImpl(repository: repository)
        )

        #expect(viewModel.isSaved == true)
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    @MainActor
    func toggleSavedAddsAndRemovesSavedState() {
        let repository = SavedPOIRepositoryForDetailTests()
        let viewModel = PlacesDetailViewModel(
            poi: samplePOI,
            getSavedPOIsUseCase: GetSavedPOIsUseCaseImpl(repository: repository),
            toggleSavedPOIUseCase: ToggleSavedPOIUseCaseImpl(repository: repository)
        )

        #expect(viewModel.isSaved == false)

        viewModel.toggleSaved()
        #expect(viewModel.isSaved == true)

        viewModel.toggleSaved()
        #expect(viewModel.isSaved == false)
    }

    @Test
    @MainActor
    func toggleSavedMapsRepositoryErrorToUserMessage() {
        let repository = SavedPOIRepositoryForDetailTests()
        repository.shouldFailOnToggle = true

        let viewModel = PlacesDetailViewModel(
            poi: samplePOI,
            getSavedPOIsUseCase: GetSavedPOIsUseCaseImpl(repository: repository),
            toggleSavedPOIUseCase: ToggleSavedPOIUseCaseImpl(repository: repository)
        )

        viewModel.toggleSaved()

        #expect(viewModel.errorMessage == "We couldn't update saved places. Please try again.")
        #expect(viewModel.isSaved == false)
    }
}
