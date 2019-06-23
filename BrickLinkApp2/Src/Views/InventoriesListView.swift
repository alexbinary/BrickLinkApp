
import SwiftUI



struct InventoriesListView : View {

    @EnvironmentObject var inventoriesStore: InventoriesStore
    
    var body: some View {

        NavigationView {
        
            List(inventoriesStore.inventories) { inventory in
                
                Text(verbatim: inventory.item.no)
            }
                .navigationBarTitle(Text("Inventory"))
        }
    }
}



#if DEBUG

struct InventoriesListView_Previews : PreviewProvider {

    static var previews: some View {

        InventoriesListView()
            .environmentObject(dummyInventoriesStore)
            .environment(\.colorScheme, .dark)
    }
}

#endif
