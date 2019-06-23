
import SwiftUI



struct InventoryRowView : View {

    let inventory: Inventory
    
    var body: some View {

        VStack(alignment: .leading) {
            Text(verbatim: inventory.item.name).lineLimit(3)
            Text(verbatim: inventory.item.no).font(.footnote)
        }
    }
}



#if DEBUG

struct InventoryRowView_Previews : PreviewProvider {

    static var allTestInventories: [Inventory] {
        dummyInventoriesStore.inventories
    }
    
    static var testInventories: [Inventory] { [
        allTestInventories[0],
        allTestInventories[4],
        allTestInventories[11]
    ] }
    
    static var previews: some View {

        ForEach(testInventories) { inventory in
        
            InventoryRowView(inventory: inventory)
        }
            .previewLayout(.sizeThatFits)
    }
}

#endif
