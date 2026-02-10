import Foundation

struct SavedPOI: Identifiable, Equatable {
    let id: Int
    let name: String
    let url: URL?
    let category: String
    let rating: Double?
    let imageURL: URL?
    let longitude: Double
    let latitude: Double
    let savedAt: Date

    func asPOI() -> POI {
        POI(
            id: id,
            name: name,
            url: url,
            category: category,
            rating: rating,
            imageURL: imageURL,
            longitude: longitude,
            latitude: latitude
        )
    }
}
