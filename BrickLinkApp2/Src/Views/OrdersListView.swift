
import SwiftUI



struct OrdersListView : View {

    @EnvironmentObject var ordersStore: OrdersStore
    
    @State var showOnlyNotCompleted = true
    
    var body: some View {

        NavigationView {

            List {
                
                Toggle(isOn: $showOnlyNotCompleted) {
                    Text("Not completed only")
                }
                
                ForEach(ordersStore.ordersMostRecentFirst) { order in
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
            .environmentObject(dummyOrdersStore)
            .environment(\.colorScheme, .dark)
    }
}

#endif
