
import SwiftUI



struct MainView : View {
    
    var body: some View {
    
        TabbedView {
            
            OrdersListView()
                .tabItemLabel(Text("Orders")).tag(1)
            
            CreateInventoryView()
                .tabItemLabel(Text("Create Inventory")).tag(2)
        }
    }
}



#if DEBUG

struct MainView_Previews : PreviewProvider {

    static var previews: some View {
        
        MainView()
            .environmentObject(dummyOrdersStore)
            .environmentObject(dummyColorsStore)
            .environmentObject(appController)
            .environment(\.colorScheme, .dark)
    }
}

#endif
