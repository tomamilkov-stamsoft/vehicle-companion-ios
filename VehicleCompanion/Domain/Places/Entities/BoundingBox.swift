import Foundation

struct BoundingBox: Equatable {
    let swLon: Double
    let swLat: Double
    let neLon: Double
    let neLat: Double

    static let candidateArea = BoundingBox(
        swLon: -84.540499,
        swLat: 39.079888,
        neLon: -84.494260,
        neLat: 39.113254
    )
}
