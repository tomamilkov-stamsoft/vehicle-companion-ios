# Vehicle Companion (iOS)

Vehicle Companion is an iOS 17+ SwiftUI app that helps a vehicle owner manage their garage and discover nearby places.

## Running

### Requirements
- Xcode 16+ (latest stable recommended)
- iOS 17.0+ deployment target
- macOS with iOS Simulator support

### Setup
1. Open `VehicleCompanion.xcodeproj` in Xcode.
2. Select the `VehicleCompanion` scheme.
3. Choose an iOS 17+ simulator (for example, iPhone 16).
4. Run the app (`Cmd+R`).

### Running tests
- In Xcode: `Cmd+U`
- Or CLI:

```bash
xcodebuild \
  -project VehicleCompanion.xcodeproj \
  -scheme VehicleCompanion \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  test
```

## Architecture & Design Choices

The app follows a layered Clean Architecture with MVVM:

- `Presentation/`: SwiftUI screens and `@Observable` view models
- `Domain/`: business entities, repository contracts, use cases
- `Data/`: repository implementations, persistence models, network data source/service
- `Main/`: app entrypoint, DI, navigation, networking infrastructure, shared utilities

### Why this structure
- View models own state and side effects.
- Use cases encapsulate user-facing business actions.
- Domain depends on contracts, not concrete storage/networking.
- Data layer provides concrete implementations (SwiftData + network).
- Dependency wiring is centralized in Swinject assemblies.

### Navigation
Custom router-based navigation is used with `NavigationStack` and tab-specific flows:
- Tabs: `Garage`, `Places`
- Root routing is handled by `AppRouter` and `FlowRouter`.

## Data Modeling (SwiftData)

SwiftData models currently included in schema (`PersistenceStack`):
- `VehicleRecord`
- `SavedPOIRecord`
- `MaintenanceItemRecord`
- `TripRecord`

### Modeling rationale
- `VehicleRecord`: stores core vehicle profile and optional hero image (`externalStorage` for image data).
- `SavedPOIRecord`: stores minimal POI snapshot needed for offline favorites (name/category/rating/location/urls).
- `MaintenanceItemRecord` and `TripRecord`: schema-ready persistence records for the remaining feature areas.

### Domain vs Data model separation
- Network DTOs (for Roadtrippers) stay in Data layer (`POIDTO`) and map into domain entities (`POI`).
- Persistence records (`*Record`) map to domain entities instead of leaking storage details into presentation.

## Networking

- Uses Alamofire via `HTTPClientImpl`.
- Uses async/await end-to-end for API requests.
- `APIClient` builds requests from endpoint definitions.
- Places discovery is backed by a small data-source/service contract and repository chain:
  - `DiscoverPOIsUseCase -> POIRepository -> POIDataSource -> POIServiceImpl`

## Error and Empty State Handling

### Error strategy
- Data and service layers expose typed/domain-oriented errors.
- Presentation maps technical failures to user-friendly messages via `UserErrorMessageMapper`.
- Places failure state includes a visible `Retry` action.

### Empty states
- Garage: explicit empty state when there are no vehicles.
- Places: explicit empty state when no visible places are available.

### Loading states
- Places shows dedicated loading indicator while discovery runs.

## Accessibility

Implemented baseline accessibility support includes:
- Dynamic Type-aware text styles and wrapping in key rows/screens
- VoiceOver labels/hints for Garage and Places list rows
- Accessible location description in Places detail

## Image Loading & Caching

- Images are loaded with `AsyncImage`.
- `URLCache` is explicitly configured at app startup through `URLCacheConfigurator`.
- Saved places persist metadata, while image bytes remain URL-based and cache-backed.

## Current Feature Scope

### Implemented
- Garage: add/view/edit/delete vehicle profiles with hero image picker
- Places: discover POIs, list/detail, save-for-later toggle, offline saved POIs

### Partially prepared
- Persistence schema includes Maintenance and Trips records, but full CRUD flows are not implemented yet.

## What I’d Build Next

If given more time, the next priorities would be:
1. Implement full Maintenance feature (domain/data/presentation + due status logic and tests).
2. Implement full Trips feature (domain/data/presentation + tests).
3. Expand UI polish and accessibility pass across all screens and edge states.
4. Add richer observability (structured logging for network/persistence failures).
