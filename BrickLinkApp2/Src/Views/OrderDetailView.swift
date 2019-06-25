
import SwiftUI



struct OrderDetailView : View {
    
    let order: Order
    
    var body: some View {

        VStack(alignment: .leading) {

            HStack {

                VStack(alignment: .leading) {
                    Text("Received").font(.caption)
                    Text(DateFormatter.localizedString(from: order.dateOrdered, dateStyle: .full, timeStyle: .short))
                }
            }

            HStack(alignment: .top) {

                VStack(alignment: .leading) {
                    Text("Buyer").font(.caption)
                    Text(order.buyerName)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    OrderStatusView(status: order.status)
                    Text("Changed " + DateFormatter.localizedString(from: order.dateStatusChanged, dateStyle: .full, timeStyle: .short))
                        .font(.caption)
                }
            }

            VStack(alignment: .leading, spacing: 9.0) {
                
                VStack(alignment: .leading) {
                    Text("Items").font(.caption)
                    Text("Total count: \(order.totalCount)")
                    Text("Unique count: \(order.uniqueCount)")
                }
                
                Text("Grand total: \(order.dispCost.grandTotal) \(order.dispCost.currencyCode)")
                    .font(.title)
            }
            
            Spacer()
        }
            .padding()
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
