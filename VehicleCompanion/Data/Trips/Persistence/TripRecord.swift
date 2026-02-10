import Foundation
import SwiftData

@Model
final class TripRecord {
    @Attribute(.unique) var id: UUID
    var vehicleID: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var notes: String?
    var createdAt: Date

    init(
        id: UUID,
        vehicleID: UUID,
        title: String,
        startDate: Date,
        endDate: Date,
        notes: String?,
        createdAt: Date
    ) {
        self.id = id
        self.vehicleID = vehicleID
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
        self.createdAt = createdAt
    }
}
