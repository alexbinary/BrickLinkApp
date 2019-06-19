
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
    @State var itemColorRawValue: Int = ColorId.blue.rawValue
    @State var itemDescription: String = ""
    @State var isStockroom = true
    @State var saleRate: String = "50"
    
    @State var autoPrice: Bool = true
    @State var priceGuidePrice: Float = 0
    
    var itemColor: ColorId { ColorId(rawValue: itemColorRawValue)! }
    
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
            isStockRoom: isStockroom,
            description: itemDescription,
            saleRate: Int(saleRate)!
        )
    }
    
    var colors: [ColorId: String] = [

        .white: "White",
        .yellow: "Yellow",
        .red:  "Red",
        .blue: "Blue",
        .lightGray: "Light Gray",
        .black: "Black",
        .darkBluishGray: "Dark Bluish Gray",
        .lightBluishGray: "Light Bluish Gray",
    ]
    var colorList: [Int] = [
        
        ColorId.white,
        ColorId.yellow,
        ColorId.red,
        ColorId.blue,
        ColorId.lightGray,
        ColorId.black,
        ColorId.darkBluishGray,
        ColorId.lightBluishGray,
        
    ] .map { $0.rawValue }
    
    var body: some View {
      
        NavigationView {
        
            List {
        
                Section {
                
                    HStack {
                        Text("Item number")
                        Spacer()
                        TextField($itemNo, placeholder: Text("93274"))
                    }
                    
                    Picker(selection: $itemColorRawValue, label: Text("Color")) {
                        ForEach(colorList) { i in
                            Text(self.colors[ColorId(rawValue: i)!]!).tag(i)
                        }
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
                            Button(action: {
                                _ = self.appController.getPriceGuide(itemNo: self.itemNo, colorId: self.itemColor)
                                    .sink { priceGuide in
                                        self.priceGuidePrice = priceGuide.avgPrice.floatValue
                                    }
                            }) {
                                Text("Price guide")
                            }
                            Text("\(priceGuidePrice)")
                            Spacer()
                            TextField($itemUnitPrice, placeholder: Text("0.24"))
                            Text("€")
                        }
                    }
                    
                    HStack {
                        Text("Sale")
                        Spacer()
                        TextField($saleRate, placeholder: Text("50"))
                        Text("%")
                    }
                    
                    Toggle(isOn: $isStockroom) {
                        Text("Stockroom")
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
            .environment(\.colorScheme, .dark)
    }
}

#endif
