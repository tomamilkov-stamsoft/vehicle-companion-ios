import Foundation
import SwiftData

@Model
final class MaintenanceItemRecord {
    @Attribute(.unique) var id: UUID
    var vehicleID: UUID
    var title: String
    var dueDate: Date
    var notes: String?
    var isDone: Bool
    var createdAt: Date

    init(
        id: UUID,
        vehicleID: UUID,
        title: String,
        dueDate: Date,
        notes: String?,
        isDone: Bool,
        createdAt: Date
    ) {
        self.id = id
        self.vehicleID = vehicleID
        self.title = title
        self.dueDate = dueDate
        self.notes = notes
        self.isDone = isDone
        self.createdAt = createdAt
    }
}
