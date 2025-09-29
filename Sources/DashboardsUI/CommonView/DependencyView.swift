import Foundation
import DashboardsCore
import SwiftUI

struct DependencyView: View {
    let dependency: Dependency
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("• Field: \(dependency.field)")
            Text("  Translation: \(dependency.translation)")
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }
}
