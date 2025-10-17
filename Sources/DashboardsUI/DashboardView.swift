import SwiftUI
import DashboardsCore
import Foundation

@available(iOS 17.0, *)
struct DashboardView: View {
    @EnvironmentObject private var core: DashboardsCore
    @StateObject private var runtime: DashboardRuntime
    
    init(dashboard: Dashboard) {
        self._runtime = StateObject(wrappedValue: .init(dashboard: dashboard))
    }
    
    var body: some View {
        let dashboard = runtime.dashboard
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(dashboard.title)
                    .font(.headline)
                if let description = dashboard.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                }
                if let revision = dashboard.revision, !revision.isEmpty {
                    Text(revision)
                        .font(.subheadline)
                }
                Text("Version: \(dashboard.version)")
                    .font(.subheadline)
                
                Divider()
                
                if !dashboard.widgets.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Widgets")
                            .font(.headline)
                        
                        ForEach(dashboard.widgets) { widget in
                            VStack(alignment: .leading, spacing: 6) {
                                WidgetView(widget: widget)
                                    .environmentObject(runtime)
                                if let dependencies = widget.dependOn, !dependencies.isEmpty {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Dependencies:")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        
                                        ForEach(dependencies, id: \.id) { dep in
                                            DependencyView(dependency: dep)
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            _ = core.isConnected
        }
    }
}
