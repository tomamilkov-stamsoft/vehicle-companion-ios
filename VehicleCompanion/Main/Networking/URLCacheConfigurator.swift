import Foundation

enum URLCacheConfigurator {
    private enum Settings {
        static let memoryCapacity = 50 * 1024 * 1024
        static let diskCapacity = 200 * 1024 * 1024
        static let diskPath = "vehicle-companion-url-cache"
    }

    static func configureDefault() {
        URLCache.shared = URLCache(
            memoryCapacity: Settings.memoryCapacity,
            diskCapacity: Settings.diskCapacity,
            diskPath: Settings.diskPath
        )
    }
}
