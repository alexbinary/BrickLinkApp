
import SwiftUI



struct OrdersListView : View {

    @EnvironmentObject var ordersStore: OrdersStore
    @State var showOnlyNotCompleted = false
    
    var body: some View {

        NavigationView {

            List {
                
                Toggle(isOn: $showOnlyNotCompleted) {
                    Text("Not completed only")
                }
                
                ForEach(ordersStore.orders.reversed()) { order in
                    if self.orderShouldBeVisible(order) {
                        OrderRowView(order: order)
                    }
                }
            }
                .navigationBarTitle(Text("My Orders"))
        }
    }
    
    func orderShouldBeVisible(_ order: Order) -> Bool {
        
        if self.showOnlyNotCompleted && order.status == .completed {
            return false
        }
        return true
    }
}



#if DEBUG

struct ContentView_Previews : PreviewProvider {

    static var previews: some View {

        OrdersListView()
            .environmentObject(testOrdersStore)
            .environment(\.colorScheme, .dark)
    }
}

#endif
