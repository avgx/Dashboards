import SwiftUI
import Foundation

struct ErrorView: View {
    let error: any Error
    let reloadAction: () -> Void
    
    public init(error: any Error, reloadAction: @escaping () -> Void) {
        self.error = error
        self.reloadAction = reloadAction
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Something went wrong")
            Text(error.localizedDescription)
                .font(.caption)
                .foregroundColor(.secondary)
            Button(
                action: self.reloadAction,
                label: {
                    Image(systemName: "arrow.clockwise")
                }
            )
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
