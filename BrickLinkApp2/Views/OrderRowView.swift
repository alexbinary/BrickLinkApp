
import SwiftUI


struct OrderRowView : View {
    
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(order.orderId.stringValue).font(.title)
                Spacer()
                VStack(alignment: .leading) {
                    Text("Received").font(.caption)
                    Text(DateFormatter.localizedString(from: order.dateOrdered, dateStyle: .full, timeStyle: .none))
                }
            }
            HStack {
                Text("Buyer: \(order.buyerName)")
                Spacer()
                VStack(alignment: .trailing) {
                    Text(order.status.rawValue)
                    Text("Changed " + DateFormatter.localizedString(from: order.dateStatusChanged, dateStyle: .full, timeStyle: .short))
                        .font(.caption)
                }
            }
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
            
        }
            .previewLayout(.sizeThatFits)
            .environment(\.locale, Locale(identifier: "fr-FR"))
    }
}
#endif
