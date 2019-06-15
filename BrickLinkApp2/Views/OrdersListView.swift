
import SwiftUI


struct OrdersListView : View {

    @EnvironmentObject var ordersStore: OrdersStore
    @State var showOnlyNotCompleted = false
    
    var body: some View {
        VStack {
            Toggle(isOn: $showOnlyNotCompleted) {
                Text("Show only not completed")
            }
            List {
                ForEach(ordersStore.orders.reversed()) { order in
                    if order.status != .completed || !self.showOnlyNotCompleted {
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
        OrdersListView()
            .environment(\.locale, Locale(identifier: "fr-FR"))
            .environmentObject(testOrdersStore)
    }
}
#endif

