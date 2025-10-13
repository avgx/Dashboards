import SwiftUI
import DashboardsCore

@available(iOS 17.0, *)
struct WidgetView: View {
    let widget: DashbordWidget
    
    var body: some View {
        Group {
            switch widget.widget {
            case "Counter":
                CounterWidgetView(widget: widget)
<<<<<<< HEAD
=======
            case "Chart":
                ChartWidgetView(widget: widget)
            case "EventsTable":
                TableWidgetView(widget: widget)
>>>>>>> 035abfa (refactoring)
            default:
                Text("Unsupported widget type: \(widget.widget)")
            }
        }
    }
}
