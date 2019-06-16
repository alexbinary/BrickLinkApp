
import SwiftUI



struct CreateInventoryView : View {
    
    @EnvironmentObject var appController: AppController
    
    enum ViewState {
        case initial
        case running
        case done
    }
    
    @State var viewState: ViewState = .initial
    
    var isRunning: Bool { viewState == .running }
    var isDone: Bool { viewState == .done }
    
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
        
            List {
        
                Section {
                
                    HStack {
                        Text("Item number")
                        Spacer()
                        TextField($itemNo)
                    }
                    
                    HStack {
                        Text("Unit price")
                        Spacer()
                        TextField($itemUnitPrice)
                    }
                }
                    .multilineTextAlignment(.trailing)
                
                Section {
                
                    Button(action: {
                        self.viewState = .running
                        _ = self.appController.create(self.currentInventory)
                            .sink {
                                self.viewState = .done
                            }
                    }) {
                        Text("Create Inventory")
                    }
                    if isRunning {
                        Text("Loading")
                    }
                    if isDone {
                        Text("Inventory created!")
                        
                    }
                }
            }
                .listStyle(.grouped)
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
