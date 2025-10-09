import SwiftUI
import DashboardsCore

struct WidgetView: View {
    let widget: DashbordWidget
    
    var body: some View {
        Group {
            switch widget.widget {
            case "Counter":
                CounterWidgetView(widget: widget)
            default:
                Text("Unsupported widget type: \(widget.widget)")
            }
        }
    }
}
