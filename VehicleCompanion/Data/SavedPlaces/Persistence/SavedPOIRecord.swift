import Foundation
import SwiftData

@Model
final class SavedPOIRecord {
    @Attribute(.unique) var id: Int
    var name: String
    var category: String
    var rating: Double?
    var imageURLString: String?
    var urlString: String?
    var longitude: Double
    var latitude: Double
    var savedAt: Date

    init(
        id: Int,
        name: String,
        category: String,
        rating: Double?,
        imageURLString: String?,
        urlString: String?,
        longitude: Double,
        latitude: Double,
        savedAt: Date
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.rating = rating
        self.imageURLString = imageURLString
        self.urlString = urlString
        self.longitude = longitude
        self.latitude = latitude
        self.savedAt = savedAt
    }
}

extension SavedPOIRecord {
    func toDomain() -> SavedPOI {
        SavedPOI(
            id: id,
            name: name,
            url: urlString.flatMap(URL.init(string:)),
            category: category,
            rating: rating,
            imageURL: imageURLString.flatMap(URL.init(string:)),
            longitude: longitude,
            latitude: latitude,
            savedAt: savedAt
        )
    }
}
