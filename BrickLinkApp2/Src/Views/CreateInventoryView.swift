
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
    @State var itemUnitPrice: String = "0.1"
    @State var itemQuantity: String = "42"
    @State var itemColor: ColorId = .blue
    @State var itemDescription: String = ""
    
    @State var autoPrice: Bool = true
    
    var currentInventory: Inventory {
        
        Inventory(
            
            item: InventoryItem(
                type: .part,
                no: itemNo
            ),
            colorId: itemColor,
            quantity: Int(itemQuantity)!,
            unitPrice: FixedPointNumber(autoPrice ? 0 : Float(itemUnitPrice)!),
            newOrUsed: .used,
            isRetain: true,
            isStockRoom: true,
            description: itemDescription
        )
    }
    
    var body: some View {
      
        NavigationView {
        
            List {
        
                Section {
                
                    HStack {
                        Text("Item number")
                        Spacer()
                        TextField($itemNo, placeholder: Text("93274"))
                    }
                    
                    Picker(selection: $itemColor, label: Text("Color")) {
//                        ForEach(ColorId.allCases) { colorId in
//                            Text(colorId.rawValue).tag(colorId)
//                        }
                        Text("blue").tag(ColorId.blue)
                        Text("red").tag(ColorId.red)
                    }
                
                    HStack {
                        Text("Quantity")
                        Spacer()
                        TextField($itemQuantity, placeholder: Text("42"))
                    }
                    
                    HStack {
                        Text("Unit price")
                        Spacer()
                        Toggle(isOn: $autoPrice) {
                            Text("auto")
                        }
                    }
                    
                    if !autoPrice {
                        HStack {
                            Spacer()
                            TextField($itemUnitPrice, placeholder: Text("0.24"))
                            Text("€")
                        }
                    }
                    
                    TextField($itemDescription, placeholder: Text("Description"))
                }
                    .multilineTextAlignment(.trailing)
                
                Section {
                
                    Button(action: {
                        self.viewState = .running
                        _ = self.appController.create(self.currentInventory, self.autoPrice)
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
