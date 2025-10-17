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
            case "Chart":
                ChartWidgetView(widget: widget)
            case "EventsTable":
                TableWidgetView(widget: widget)
            case "RangeBarChart":
                ChartWidgetView(widget: widget)
            default:
                Text("Unsupported widget type: \(widget.widget)")
            }
        }
    }
}
