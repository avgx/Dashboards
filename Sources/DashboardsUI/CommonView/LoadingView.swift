import SwiftUI
import Foundation

struct LoadingView: View {
    let message: String
    
    var body: some View {
        VStack {
            ProgressView()
            Text(message)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
