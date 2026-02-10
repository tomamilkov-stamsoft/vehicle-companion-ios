import Foundation

@MainActor
@Observable
final class PlacesDetailViewModel {
    let poi: POI
    private let getSavedPOIsUseCase: GetSavedPOIsUseCase
    private let toggleSavedPOIUseCase: ToggleSavedPOIUseCase

    private(set) var isSaved: Bool
    var errorMessage: String?

    init(
        poi: POI,
        getSavedPOIsUseCase: GetSavedPOIsUseCase,
        toggleSavedPOIUseCase: ToggleSavedPOIUseCase
    ) {
        self.poi = poi
        self.getSavedPOIsUseCase = getSavedPOIsUseCase
        self.toggleSavedPOIUseCase = toggleSavedPOIUseCase
        self.isSaved = false

        refreshSavedState()
    }

    func toggleSaved() {
        do {
            try toggleSavedPOIUseCase.execute(poi)
            refreshSavedState()
            errorMessage = nil
        } catch {
            errorMessage = UserErrorMessageMapper.message(for: error)
        }
    }

    private func refreshSavedState() {
        do {
            let saved = try getSavedPOIsUseCase.execute()
            isSaved = saved.contains(where: { $0.id == poi.id })
        } catch {
            isSaved = false
            errorMessage = UserErrorMessageMapper.message(for: error)
        }
    }
}
