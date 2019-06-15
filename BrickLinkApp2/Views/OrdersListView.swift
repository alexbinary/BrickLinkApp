
import SwiftUI


struct OrdersListView : View {
    
    var orders: [Order]
    @State var showOnlyNotCompleted = false
    
    var body: some View {
        VStack {
            Toggle(isOn: $showOnlyNotCompleted) {
                Text("Show only not completed")
            }
            List {
                ForEach(orders.reversed()) { order in
                    if order.status != .completed || !self.showOnlyNotCompleted {
                        OrderRowView(order: order)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        OrdersListView(orders: testOrders)
            .environment(\.locale, Locale(identifier: "fr-FR"))
    }
}
#endif

