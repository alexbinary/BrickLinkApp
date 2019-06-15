
import SwiftUI



struct CreateInventoryView : View {
    
    enum ViewState {
        case initial
        case running
        case done
    }
    
    @State var viewState: ViewState = .initial
    @State var itemNo: String = "93274"
    
    var body: some View {
      
        NavigationView {
        
            VStack {
        
                HStack {
                    Text("Item number")
                    TextField($itemNo)
                }
                
                Button(action: {
                    self.viewState = .running
                    appController.createInventory(itemNo: self.itemNo) {
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
    }
}

#endif
