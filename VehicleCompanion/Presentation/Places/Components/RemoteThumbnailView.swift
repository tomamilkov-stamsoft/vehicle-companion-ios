import SwiftUI

struct RemoteThumbnailView: View {
    let url: URL?
    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat

    init(
        url: URL?,
        width: CGFloat? = nil,
        height: CGFloat,
        cornerRadius: CGFloat
    ) {
        self.url = url
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        AsyncImage(
            url: url,
            transaction: Transaction(animation: .easeInOut(duration: 0.2))
        ) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(maxWidth: width ?? .infinity, minHeight: height, maxHeight: height)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: width ?? .infinity, minHeight: height, maxHeight: height)
                    .clipped()
            case .failure:
                Image(systemName: "photo")
                    .frame(maxWidth: width ?? .infinity, minHeight: height, maxHeight: height)
                    .background(Color.gray.opacity(0.15))
            @unknown default:
                EmptyView()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
