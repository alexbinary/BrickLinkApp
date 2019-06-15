
import SwiftUI



struct MainView : View {
    
    var body: some View {
    
        TabbedView {
            
            OrdersListView()
                .tabItemLabel(Text("Orders")).tag(1)
            
            CreateInventoryView()
                .tabItemLabel(Text("Inventory")).tag(2)
        }
    }
}



#if DEBUG

struct MainView_Previews : PreviewProvider {

    static var previews: some View {
        
        MainView()
            .environmentObject(testOrdersStore)
    }
}

#endif