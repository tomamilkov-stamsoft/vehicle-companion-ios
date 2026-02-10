import Foundation

struct POIDiscoverResponseDTO: Decodable {
    let pois: [POIDTO]
}

struct POIDTO: Decodable {
    let id: Int
    let name: String
    let url: URL?
    let primaryCategoryDisplayName: String
    let rating: Double?
    let imageURL: URL?
    let longitude: Double
    let latitude: Double

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case primaryCategoryDisplayName = "primary_category_display_name"
        case rating
        case imageURL = "v_320x320_url"
        case loc
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        primaryCategoryDisplayName = try container.decodeIfPresent(String.self, forKey: .primaryCategoryDisplayName) ?? "Unknown"
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)

        let loc = try container.decodeIfPresent([Double].self, forKey: .loc) ?? []
        guard loc.count == 2 else {
            throw DecodingError.dataCorruptedError(
                forKey: .loc,
                in: container,
                debugDescription: "Expected loc with exactly 2 elements [lon, lat]"
            )
        }

        longitude = loc[0]
        latitude = loc[1]
    }
}

extension POIDTO {
    func toDomain() -> POI {
        POI(
            id: id,
            name: name,
            url: url,
            category: primaryCategoryDisplayName,
            rating: rating,
            imageURL: imageURL,
            longitude: longitude,
            latitude: latitude
        )
    }
}
