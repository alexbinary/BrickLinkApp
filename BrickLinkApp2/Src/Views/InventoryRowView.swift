
import SwiftUI



struct InventoryRowView : View {

    let inventory: Inventory
    
    var body: some View {

        VStack(alignment: .leading) {
            Text(verbatim: inventory.item.name).lineLimit(nil)
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text(verbatim: inventory.item.no).font(.footnote)
                    Text(verbatim: inventory.colorName)
                    Text(verbatim: inventory.newOrUsed.rawValue)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(verbatim: "Qty: \(inventory.quantity)")
                    Text(verbatim: "SR: \(inventory.isStockRoom)")
                    Text(verbatim: "\(inventory.saleRate)% off")
                }
            }
            if inventory.description.count > 0 {
                Text(verbatim: inventory.description)
                    .lineLimit(nil)
                    .font(.body)
            }
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
        allTestInventories[11],
        allTestInventories.first(where: { $0.description.count > 0 })!,
    ] }
    
    static var previews: some View {

        ForEach(testInventories) { inventory in
        
            InventoryRowView(inventory: inventory)
        }
            .previewLayout(.sizeThatFits)
    }
}

#endif
