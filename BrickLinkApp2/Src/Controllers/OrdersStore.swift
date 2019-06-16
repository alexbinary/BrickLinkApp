
import Foundation
import SwiftUI
import Combine



class OrdersStore: BindableObject {

    
    let didChange = PassthroughSubject<Void, Never>()
    
    
    var orders: [Order] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(())
            }
        }
    }
    
    
    var ordersMostRecentFirst: [Order] {
        orders.sorted { $0.dateOrdered > $1.dateOrdered }
    }
}
