import Foundation
import SwiftData

@MainActor
final class PersistenceStack {
    let container: ModelContainer

    init() {
        do {
            let schema = Schema([
                VehicleRecord.self
            ])
            let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }
}
