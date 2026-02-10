import Foundation

@MainActor
@Observable
final class PlacesViewModel {
    enum SortOption: String, CaseIterable, Identifiable {
        case rating = "Rating"
        case name = "Name"

        var id: String { rawValue }
    }

    private let discoverPOIsUseCase: DiscoverPOIsUseCase
    private let getSavedPOIsUseCase: GetSavedPOIsUseCase
    weak var router: AppRouter?

    private(set) var places: [POI] = []
    private(set) var savedPOIs: [SavedPOI] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    var sortOption: SortOption = .rating
    var favoritesOnly = false

    init(
        discoverPOIsUseCase: DiscoverPOIsUseCase,
        getSavedPOIsUseCase: GetSavedPOIsUseCase
    ) {
        self.discoverPOIsUseCase = discoverPOIsUseCase
        self.getSavedPOIsUseCase = getSavedPOIsUseCase
    }

    var displayPOIs: [POI] {
        let source: [POI]
        if favoritesOnly {
            source = savedPOIs.map { $0.asPOI() }
        } else {
            source = places
        }

        switch sortOption {
        case .rating:
            return source.sorted {
                let lhs = $0.rating ?? -1
                let rhs = $1.rating ?? -1
                if lhs == rhs { return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                return lhs > rhs
            }
        case .name:
            return source.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            savedPOIs = try getSavedPOIsUseCase.execute()
        } catch {
            errorMessage = UserErrorMessageMapper.message(for: error)
        }

        do {
            places = try await discoverPOIsUseCase.execute(in: .candidateArea, pageSize: 50)
        } catch {
            if places.isEmpty {
                errorMessage = UserErrorMessageMapper.message(for: error)
            }
        }

        isLoading = false
    }

    func isSaved(_ poi: POI) -> Bool {
        savedPOIs.contains(where: { $0.id == poi.id })
    }

    func didSelectPOI(_ poi: POI) {
        router?.push(.placeDetail(poi: poi))
    }
}
