import SwiftUI
import DashboardsCore
import SafariServices

@available(iOS 17.0, *)
struct WidgetView: View {
    @EnvironmentObject private var core: DashboardsCore
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
            default:
                unsupportedWidgetView
            }
        }
    }
    
    private var unsupportedWidgetView: some View {
        VStack(spacing: 12) {
            Text(widget.title)
                .font(.headline)
            Text("Этот виджет пока не поддерживается нативно.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 1)
    }
    
    
}
