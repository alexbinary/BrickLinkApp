
import SwiftUI


struct OrdersListView : View {
    
    var orders: [Order]
    
    var body: some View {
        List(orders) { order in
            OrderRowView(order: order)
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

