import UIKit

enum ImageCompression {
    static func compressJPEG(_ data: Data, quality: CGFloat = 0.75) -> Data {
        guard let image = UIImage(data: data), let compressed = image.jpegData(compressionQuality: quality) else {
            return data
        }
        return compressed
    }
}
