import Foundation
import Testing
@testable import VehicleCompanion

private struct DiscoverPOIsUseCaseMock: DiscoverPOIsUseCase {
    var result: Result<[POI], Error>

    func execute(in bbox: BoundingBox, pageSize: Int) async throws -> [POI] {
        try result.get()
    }
}

private final class SavedPOIRepositoryMock: SavedPOIRepository {
    var saved: [SavedPOI] = []

    func fetchAll() throws -> [SavedPOI] {
        saved
    }

    func upsert(_ poi: POI) throws {
        if !saved.contains(where: { $0.id == poi.id }) {
            saved.insert(
                SavedPOI(
                    id: poi.id,
                    name: poi.name,
                    url: poi.url, category: poi.category,
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
        saved.removeAll(where: { $0.id == id })
    }

    func isSaved(id: Int) throws -> Bool {
        saved.contains(where: { $0.id == id })
    }
}

struct PlacesViewModelTests {
    @Test
    @MainActor
    func sortingAndFavoritesFilteringWorks() async {
        let repository = SavedPOIRepositoryMock()
        let discover = DiscoverPOIsUseCaseMock(result: .success([
            POI(id: 1, name: "Zoo", url: nil, category: "Fun", rating: 3, imageURL: nil, longitude: 1, latitude: 1),
            POI(id: 2, name: "Aquarium", url: nil, category: "Fun", rating: 5, imageURL: nil, longitude: 2, latitude: 2)
        ]))

        let viewModel = PlacesViewModel(
            discoverPOIsUseCase: discover,
            getSavedPOIsUseCase: GetSavedPOIsUseCaseImpl(repository: repository),
            toggleSavedPOIUseCase: ToggleSavedPOIUseCaseImpl(repository: repository)
        )

        await viewModel.load()
        #expect(viewModel.displayPOIs.map(\.id) == [2, 1])

        viewModel.sortOption = .name
        #expect(viewModel.displayPOIs.map(\.id) == [2, 1])

        viewModel.toggleSaved(viewModel.displayPOIs[0])
        viewModel.favoritesOnly = true
        #expect(viewModel.displayPOIs.count == 1)
    }

    @Test
    @MainActor
    func errorStateIsSetWhenDiscoveryFailsAndNoSavedPOIs() async {
        enum DummyError: Error { case failed }

        let repository = SavedPOIRepositoryMock()
        let viewModel = PlacesViewModel(
            discoverPOIsUseCase: DiscoverPOIsUseCaseMock(result: .failure(DummyError.failed)),
            getSavedPOIsUseCase: GetSavedPOIsUseCaseImpl(repository: repository),
            toggleSavedPOIUseCase: ToggleSavedPOIUseCaseImpl(repository: repository)
        )

        await viewModel.load()

        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.displayPOIs.isEmpty)
    }
}
