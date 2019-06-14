
import SwiftUI


struct OrdersListView : View {
    
    var orders: [Order]
    @State var selectedStatus = 0
    
    var body: some View {
        VStack {
            SegmentedControl(selection: $selectedStatus) {
                ForEach(0..<OrderStatus.allCases.count) { index in
                    Text(OrderStatus.allCases[index].rawValue).tag(index)
                }
            }
            List {
                ForEach(orders) { order in
                    if order.status == OrderStatus.allCases[self.selectedStatus] {
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

