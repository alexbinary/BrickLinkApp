
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
    
    struct FormModel {
        
        var itemNo: String = "93274"
        var unitPriceAuto: Bool = true
        var unitPrice: String = "0.1"
        var colorId: Int = 1
        var quantity: String = "42"
        var description: String = ""
        var isStockroom = true
        var saleRate: String = "50"
        
        var inventory: Inventory {
            
            Inventory(
                
                item: InventoryItem(
                    type: .part,
                    no: itemNo
                ),
                colorId: colorId,
                quantity: Int(quantity)!,
                unitPrice: FixedPointNumber(unitPriceAuto ? 0 : Float(unitPrice)!),
                newOrUsed: .used,
                isRetain: true,
                isStockRoom: isStockroom,
                description: description,
                saleRate: Int(saleRate)!
            )
        }
    }
    
    @State var formModel = FormModel()
    
    @State var loadedPriceGuidePrice: Float = 0
    
    var body: some View {
      
        NavigationView {
        
            List {

                Section {

                    HStack {
                        Text("Item number")
                        Spacer()
                        TextField($formModel.itemNo, placeholder: Text("93274"))
                    }
                    
                    Picker(selection: $formModel.colorId, label: Text("Color")) {
                        ForEach(self.colorsStore.colors) { color in
                            Text(verbatim: color.colorName).tag(color.colorId)
                        }
                    }

                    HStack {
                        Text("Quantity")
                        Spacer()
                        TextField($formModel.quantity, placeholder: Text("42"))
                    }

                    HStack {
                        Text("Unit price")
                        Spacer()
                        Toggle(isOn: $formModel.unitPriceAuto) {
                            Text("auto")
                        }
                    }

                    if !formModel.unitPriceAuto {
                        HStack {
                            Button(action: {
                                _ = self.appController.getPriceGuide(itemNo: self.formModel.itemNo, colorId: self.formModel.colorId)
                                    .sink { priceGuide in
                                        self.loadedPriceGuidePrice = priceGuide.avgPrice.floatValue
                                    }
                            }) {
                                Text("Price guide")
                            }
                            Text("\(loadedPriceGuidePrice)")
                            Spacer()
                            TextField($formModel.unitPrice, placeholder: Text("0.24"))
                            Text("€")
                        }
                    }

                    HStack {
                        Text("Sale")
                        Spacer()
                        TextField($formModel.saleRate, placeholder: Text("50"))
                        Text("%")
                    }

                    Toggle(isOn: $formModel.isStockroom) {
                        Text("Stockroom")
                    }

                    TextField($formModel.description, placeholder: Text("Description"))
                }
                    .multilineTextAlignment(.trailing)

                Section {

                    Button(action: {
                        self.actionState = .running
                        _ = self.appController.create(self.formModel.inventory, self.formModel.unitPriceAuto)
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
                    ForEach(0..<7) { _ in
                        Text(verbatim: "")
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
            .environmentObject(dummyColorsStore)
            .environment(\.colorScheme, .dark)
    }
}

#endif
