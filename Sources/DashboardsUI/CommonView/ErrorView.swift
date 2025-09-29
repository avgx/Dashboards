import SwiftUI
import Foundation

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Something went wrong")
            Text(error.localizedDescription)
                .font(.caption)
                .foregroundColor(.secondary)
            Button("Retry", action: retryAction)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
