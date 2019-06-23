
import SwiftUI



struct InventoriesListView : View {

    @EnvironmentObject var inventoriesStore: InventoriesStore
    @EnvironmentObject var appController: AppController
    @EnvironmentObject var colorsStore: ColorsStore
    
    @State private var searchQuery: String = "12" {
        didSet {
            print("ok")
        }
    }
    
    var body: some View {

        NavigationView {
        
            List {
                
                TextField(inventoriesStore.query, placeholder: Text("Search inventory"))
                
                ForEach(inventoriesStore.filteredInventories) { inventory in
                    if inventory.matches(query: self.searchQuery) {
                        InventoryRowView(inventory: inventory)
                    }
                }
            }
                .navigationBarTitle(Text("Inventory"))
                .navigationBarItems(
                    trailing: PresentationButton(destination:
                        CreateInventoryView()
                            .environmentObject(appController)
                            .environmentObject(colorsStore)
                ) {
                    Text("Add")
                })
        }
    }
}



#if DEBUG

struct InventoriesListView_Previews : PreviewProvider {

    static var previews: some View {

        InventoriesListView()
            .environmentObject(dummyInventoriesStore)
            .environmentObject(dummyColorsStore)
            .environmentObject(appController)
            .environment(\.colorScheme, .dark)
    }
}

#endif
