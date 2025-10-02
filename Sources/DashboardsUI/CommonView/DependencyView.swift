import Foundation
import DashboardsCore
import SwiftUI

struct DependencyView: View {
    let dependency: Dependency
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Field: \(dependency.field)")
            
            if let translation = dependency.translation, !translation.isEmpty {
                Text("Translation: \(translation)")
            }
          
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }
}
