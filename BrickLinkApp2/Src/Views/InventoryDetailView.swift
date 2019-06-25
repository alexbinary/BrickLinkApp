
import SwiftUI



struct InventoryDetailView : View {

    let inventory: Inventory
    
    var body: some View {

        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "dot.square.fill")
                Text(verbatim: inventory.item.name).lineLimit(nil)
            }
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(verbatim: inventory.item.no).font(.footnote)
                    Text(verbatim: inventory.colorName)
                    Text(verbatim: inventory.newOrUsed.description)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(verbatim: "Qty: \(inventory.quantity)")
                        .padding(.leading, 8)
                        .padding(.trailing, 8)
                        .padding(.top, 3)
                        .padding(.bottom, 3)
                        .background(Color.gray)
                        .cornerRadius(3)
                    Text(verbatim: "stockroom: \(inventory.isStockRoom ? "Y" : "N")")
                        .padding(.leading, 8)
                        .padding(.trailing, 8)
                        .padding(.top, 3)
                        .padding(.bottom, 3)
                        .background(inventory.isStockRoom ? Color.red : Color.green)
                        .cornerRadius(3)
                    Text(verbatim: "\(inventory.saleRate)% off")
                        .padding(.leading, 8)
                        .padding(.trailing, 8)
                        .padding(.top, 3)
                        .padding(.bottom, 3)
                        .background(Color.orange)
                        .cornerRadius(3)
                }
            }
            if inventory.description.count > 0 {
                Text(verbatim: inventory.description)
                    .lineLimit(nil)
                    .font(.body)
            }
            Spacer()
        }
            .padding()
            .navigationBarTitle(Text(verbatim: inventory.item.no))
    }
}



#if DEBUG

struct InventoryDetailView_Previews : PreviewProvider {

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
            NavigationView {
                InventoryDetailView(inventory: inventory)
            }
        }
    }
}

#endif
