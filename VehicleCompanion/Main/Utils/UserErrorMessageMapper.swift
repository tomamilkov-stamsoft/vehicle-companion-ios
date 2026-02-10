import Foundation

enum UserErrorMessageMapper {
    static func message(for error: Error) -> String {
        switch error {
        case let error as POIServiceError:
            switch error {
            case .invalidURL:
                return "Something is wrong with the places request."
            case .transport:
                return "We couldn't connect to Places. Check your internet connection and try again."
            case .decoding:
                return "Places data couldn't be read right now. Please try again."
            case .server:
                return "Places is temporarily unavailable. Please try again in a moment."
            case .emptyResponse:
                return "No places found for this area."
            }
        case is VehicleRepositoryError:
            return "We couldn't load your vehicles right now. Please try again."
        case is SavedPOIRepositoryError:
            return "We couldn't update saved places. Please try again."
        default:
            return "Something went wrong. Please try again."
        }
    }
}
