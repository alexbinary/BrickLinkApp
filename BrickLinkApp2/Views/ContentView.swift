
import SwiftUI


struct ContentView : View {
    @State var orders: [Order]
    func setOrders(_ orders: [Order]) {
        self.orders = orders
    }
    var body: some View {
        List(orders.identified(by: \.orderId)) { order in
            VStack(alignment: .leading) {
                Text("Id: \(order.orderId)")
                Text("Date: \(order.dateOrdered)")
                Text("Buyer: \(order.buyerName)")
                Text("Status: \(order.status.rawValue)")
                Text("Changed: \(order.dateStatusChanged)")
            }
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
