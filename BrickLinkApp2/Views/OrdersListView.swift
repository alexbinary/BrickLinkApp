
import SwiftUI


struct OrdersListView : View {
    
    var orders: [Order]
    
    var body: some View {
        List(orders.identified(by: \.orderId)) { order in
            OrderRowView(order: order)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        OrdersListView(orders: testOrders)
    }
}
#endif

