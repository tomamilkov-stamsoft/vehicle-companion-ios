import Foundation

struct POI: Identifiable, Hashable {
    let id: Int
    let name: String
    let url: URL?
    let category: String
    let rating: Double?
    let imageURL: URL?
    let longitude: Double
    let latitude: Double
}
