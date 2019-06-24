
import SwiftUI



struct OrderDetailView : View {
    
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
            .navigationBarTitle(Text(verbatim: order.orderId.stringValue))
    }
}



#if DEBUG

struct OrderDetailView_Previews : PreviewProvider {
    
    static var statuses: [OrderStatus] {
        return OrderStatus.allCases.filter { status in
            dummyOrdersStore.orders.last(where: { order in
                order.status == status
            }) != nil
        }
    }
    
    static var previews: some View {

        Group {
            ForEach(0..<statuses.count) { index in
                NavigationView {
                    OrderDetailView(order: dummyOrdersStore.orders.last(where: { $0.status == statuses[index] })!)
                }
            }
        }
            .environment(\.locale, Locale(identifier: "fr-FR"))
    }
}

#endif
