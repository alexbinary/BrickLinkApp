
import SwiftUI



struct CreateInventoryView : View {
    
    @EnvironmentObject var appController: AppController
    
    enum ViewState {
        case initial
        case running
        case done
    }
    
    @State var viewState: ViewState = .initial
    
    @State var itemNo: String = "93274"
    @State var itemUnitPrice: String = "0"
    
    var currentInventory: Inventory {
        
        Inventory(
            
            item: InventoryItem(
                type: .part,
                no: itemNo
            ),
            colorId: .blue,
            quantity: 1,
            unitPrice: FixedPointNumber(Float(itemUnitPrice)!),
            newOrUsed: .used,
            isRetain: true,
            isStockRoom: true
        )
    }
    
    var body: some View {
      
        NavigationView {
        
            VStack {
        
                HStack {
                    Text("Item number")
                    TextField($itemNo)
                }
                
                HStack {
                    Text("Unit price")
                    TextField($itemUnitPrice)
                }
                
                Button(action: {
                    self.viewState = .running
                    _ = self.appController.create(self.currentInventory)
                        .sink {
                            self.viewState = .done
                        }
                }) {
                    viewState == .initial ? Text("Create Inventory") : ( viewState == .running ? Text("") : Text("Inventory created!"))
                }
                if viewState == .running {
                    Text("Loading")
                }
            }
                .navigationBarTitle(Text("My Inventory"))
        }
    }
}



#if DEBUG

struct CreateInventoryView_Previews : PreviewProvider {

    static var previews: some View {

        CreateInventoryView()
            .environmentObject(appController)
            .environment(\.colorScheme, .dark)
    }
}

#endif
