
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
            HStack(alignment: .top) {
                Text(order.buyerName)
                Spacer()
                VStack(alignment: .trailing) {
                    OrderStatusView(status: order.status)
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
            ForEach(0..<OrderStatus.allCases.count) { index in
                OrderRowView(order: testOrders.last(where: { $0.status == OrderStatus.allCases[index] })!)
            }
        }
            .previewLayout(.sizeThatFits)
            .environment(\.locale, Locale(identifier: "fr-FR"))
    }
}
#endif

let statusColors = [
    OrderStatus.completed: Color.green,
    OrderStatus.shipped: Color.blue,
    OrderStatus.received: Color.orange,
    OrderStatus.paid: Color.red
]

struct OrderStatusView : View {
    let status: OrderStatus
    var body: some View {
        return Text(status.rawValue)
            .padding(.leading, 8)
            .padding(.trailing, 8)
            .padding(.top, 3)
            .padding(.bottom, 3)
            .background(statusColors[status])
            .cornerRadius(8)
    }
}
