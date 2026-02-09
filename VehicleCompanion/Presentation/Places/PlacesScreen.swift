import SwiftUI

struct PlacesScreen: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "map.fill")
                .font(.system(size: 44))
                .foregroundStyle(.green)

            Text("Places")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Roadtrippers results will appear here.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .navigationTitle("Places")
    }
}

#Preview {
    NavigationStack {
        PlacesScreen()
    }
}
