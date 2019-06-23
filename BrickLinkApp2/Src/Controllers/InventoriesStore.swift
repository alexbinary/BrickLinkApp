
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
}
