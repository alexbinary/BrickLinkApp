
import SwiftUI


struct ContentView : View {
    
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
        ContentView(orders: testOrders)
    }
}
#endif

