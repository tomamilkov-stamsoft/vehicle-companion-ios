import SwiftUI

struct GarageScreen: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "car.fill")
                .font(.system(size: 44))
                .foregroundStyle(.blue)

            Text("Garage")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Vehicle profiles will appear here.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .navigationTitle("Garage")
    }
}

#Preview {
    NavigationStack {
        GarageScreen()
    }
}
