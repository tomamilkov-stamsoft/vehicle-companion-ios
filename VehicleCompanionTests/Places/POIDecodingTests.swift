import Foundation
import Testing
@testable import VehicleCompanion

struct POIDecodingTests {
    @Test
    @MainActor
    func poiDecodingSupportsOptionalFields() throws {
        let json = """
        {
          "pois": [
            {
              "id": 1,
              "name": "Museum",
              "primary_category_display_name": "Attraction",
              "loc": [-84.5, 39.1]
            }
          ]
        }
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(POIDiscoverResponseDTO.self, from: json)
        #expect(decoded.pois.count == 1)
        #expect(decoded.pois[0].rating == nil)
        #expect(decoded.pois[0].imageURL == nil)
    }

    @Test
    @MainActor
    func poiDecodingFailsForMalformedLoc() {
        let json = """
        {
          "pois": [
            {
              "id": 1,
              "name": "Museum",
              "primary_category_display_name": "Attraction",
              "loc": [-84.5]
            }
          ]
        }
        """.data(using: .utf8)!

        do {
            _ = try JSONDecoder().decode(POIDiscoverResponseDTO.self, from: json)
            Issue.record("Expected malformed loc decoding failure")
        } catch {
            #expect(true)
        }
    }
}
