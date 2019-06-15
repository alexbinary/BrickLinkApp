
import SwiftUI



struct OrdersListView : View {

    @EnvironmentObject var ordersStore: OrdersStore
    @State var showOnlyNotCompleted = false
    
    var body: some View {

        NavigationView {

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
                .navigationBarTitle(Text("My Orders"))
        }
    }
}



#if DEBUG

struct ContentView_Previews : PreviewProvider {

    static var previews: some View {

        OrdersListView()
            .environmentObject(testOrdersStore)
    }
}

#endif
