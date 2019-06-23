
import SwiftUI



struct InventoriesListView : View {

    @EnvironmentObject var inventoriesStore: InventoriesStore
    @EnvironmentObject var appController: AppController
    @EnvironmentObject var colorsStore: ColorsStore
    
    var body: some View {

        NavigationView {
        
            List(inventoriesStore.inventories) { inventory in
                
                Text(verbatim: inventory.item.no)
            }
                .navigationBarTitle(Text("Inventory"))
                .navigationBarItems(
                    trailing: PresentationButton(destination:
                        CreateInventoryView()
                            .environmentObject(appController)
                            .environmentObject(colorsStore)
                ) {
                    Image(systemName: "plus")
                })
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
