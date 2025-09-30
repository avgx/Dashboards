import Foundation
import DashboardsCore
import SwiftUI

struct WidgetView: View {
    let widget: DashbordWidget
    
    var body: some View {
        Text(widget.title)
            .font(.subheadline)
            .bold()
        
        Text(widget.widget)
            .font(.footnote)
            .foregroundColor(.secondary)
    }
}
