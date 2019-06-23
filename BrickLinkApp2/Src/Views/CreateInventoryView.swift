
import SwiftUI



struct CreateInventoryView : View {
    
    @EnvironmentObject var appController: AppController
    @EnvironmentObject var colorsStore: ColorsStore
    
    enum ActionState {
        case initial
        case running
        case done
    }
    
    @State var actionState: ActionState = .initial
    
    var actionIsRunning: Bool { actionState == .running }
    var actionIsDone: Bool { actionState == .done }
    
    @State var itemNoFormValue: String = "93274"
    @State var selectedUnitPrice: String = "0.1"
    @State var selectedColorId: Int = 1
    @State var selectedQuantity: String = "42"
    @State var selectedDescription: String = ""
    @State var selectedIsStockroom = true
    @State var selectedSaleRate: String = "50"
    
    @State var autoPriceEnabled: Bool = true
    @State var loadedPriceGuidePrice: Float = 0
    
    var inventoryFromFormValues: Inventory {
        
        Inventory(
            
            item: InventoryItem(
                type: .part,
                no: itemNoFormValue
            ),
            colorId: selectedColorId,
            quantity: Int(selectedQuantity)!,
            unitPrice: FixedPointNumber(autoPriceEnabled ? 0 : Float(selectedUnitPrice)!),
            newOrUsed: .used,
            isRetain: true,
            isStockRoom: selectedIsStockroom,
            description: selectedDescription,
            saleRate: Int(selectedSaleRate)!
        )
    }
    
    var body: some View {
      
        NavigationView {
        
            List {

                Section {

                    HStack {
                        Text("Item number")
                        Spacer()
                        TextField($itemNoFormValue, placeholder: Text("93274"))
                    }
                    
                    Picker(selection: $selectedColorId, label: Text("Color")) {
                        ForEach(self.colorsStore.colors) { color in
                            Text(verbatim: color.colorName).tag(color.colorId)
                        }
                    }

                    HStack {
                        Text("Quantity")
                        Spacer()
                        TextField($selectedQuantity, placeholder: Text("42"))
                    }

                    HStack {
                        Text("Unit price")
                        Spacer()
                        Toggle(isOn: $autoPriceEnabled) {
                            Text("auto")
                        }
                    }

                    if !autoPriceEnabled {
                        HStack {
                            Button(action: {
                                _ = self.appController.getPriceGuide(itemNo: self.itemNoFormValue, colorId: self.selectedColorId)
                                    .sink { priceGuide in
                                        self.loadedPriceGuidePrice = priceGuide.avgPrice.floatValue
                                    }
                            }) {
                                Text("Price guide")
                            }
                            Text("\(loadedPriceGuidePrice)")
                            Spacer()
                            TextField($selectedUnitPrice, placeholder: Text("0.24"))
                            Text("€")
                        }
                    }

                    HStack {
                        Text("Sale")
                        Spacer()
                        TextField($selectedSaleRate, placeholder: Text("50"))
                        Text("%")
                    }

                    Toggle(isOn: $selectedIsStockroom) {
                        Text("Stockroom")
                    }

                    TextField($selectedDescription, placeholder: Text("Description"))
                }
                    .multilineTextAlignment(.trailing)

                Section {

                    Button(action: {
                        self.actionState = .running
                        _ = self.appController.create(self.inventoryFromFormValues, self.autoPriceEnabled)
                            .sink {
                                self.actionState = .done
                            }
                    }) {
                        Text("Create Inventory")
                    }
                    if actionIsRunning {
                        Text("Loading")
                    }
                    if actionIsDone {
                        Text("Inventory created!")

                    }
                }

                Section {

                    Text("")
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                    Text("")
                    Text("")
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
            .environmentObject(dummyColorsStore)
            .environment(\.colorScheme, .dark)
    }
}

#endif
