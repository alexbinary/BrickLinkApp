
import Foundation
import SwiftUI
import Combine



class InventoriesStore: BindableObject {

    
    let didChange = PassthroughSubject<Void, Never>()
    
    
    var inventories: [Inventory] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(())
            }
        }
    }
    
    
    var _query: String = ""
    
    lazy var query: Binding<String> = Binding<String>(
        getValue: {
            return self._query
        },
        setValue: { v in
            self._query = v
            self.updateFilteredInventories()
        }
    )
    
    
    func updateFilteredInventories() {
        filteredInventories = inventories.filter { $0.matches(query: _query) }
    }
    
    
    var filteredInventories: [Inventory] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(())
            }
        }
    }
}
