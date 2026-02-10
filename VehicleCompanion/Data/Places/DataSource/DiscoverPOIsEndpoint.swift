import Foundation

struct DiscoverPOIsEndpoint: APIEndpoint {
    let bbox: BoundingBox
    let pageSize: Int

    var path: String { "/pois/discover" }

    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "sw_corner", value: "\(bbox.swLon),\(bbox.swLat)"),
            URLQueryItem(name: "ne_corner", value: "\(bbox.neLon),\(bbox.neLat)"),
            URLQueryItem(name: "page_size", value: "\(pageSize)")
        ]
    }
}
