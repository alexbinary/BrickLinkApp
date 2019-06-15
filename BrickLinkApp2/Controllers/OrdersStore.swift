
import Foundation
import SwiftUI
import Combine



class OrdersStore: BindableObject {
    
    let didChange = PassthroughSubject<OrdersStore, Never>()
    
    var orders: [Order] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
}
