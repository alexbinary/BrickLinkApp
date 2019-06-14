
import SwiftUI


struct OrderRowView : View {
    
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Id: \(order.orderId)")
            Text("Date: \(order.dateOrdered)")
            Text("Buyer: \(order.buyerName)")
            Text("Status: \(order.status.rawValue)")
            Text("Changed: \(order.dateStatusChanged)")
        }
    }
}

#if DEBUG
struct OrderRowView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            
            OrderRowView(order: testOrders[23])
            OrderRowView(order: testOrders[22])
            OrderRowView(order: testOrders[0])
            
        }.previewLayout(.sizeThatFits)
    }
}
#endif
