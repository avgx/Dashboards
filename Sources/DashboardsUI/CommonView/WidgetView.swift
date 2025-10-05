import Foundation
import DashboardsCore
import SwiftUI

struct WidgetView: View {
    let widget: DashbordWidget
    @ObservedObject var core: DashboardsCore  
    
    var body: some View {
        let resource = core.widgetData[widget.id] ?? .pending
        
        switch resource {
        case .pending, .loading:
            ProgressView("Loading...")
                .padding()
            
        case .success(let response):
            VStack(alignment: .leading, spacing: 4) {
                Text("Rows: \(response.result.count)")
                    .font(.subheadline)
                    .bold()
                
                ForEach(response.result.indices, id: \.self) { i in
                    Text(response.result[i].description)
                        .font(.caption)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            .padding()
            
        case .error(let error):
            Text("Error: \(error.localizedDescription)")
                .foregroundColor(.red)
                .padding()
        }
    }
}
