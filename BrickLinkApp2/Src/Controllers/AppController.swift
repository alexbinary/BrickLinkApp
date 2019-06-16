
import Foundation
import SwiftUI
import Combine



class AppController: BindableObject {
    
    
    let didChange = PassthroughSubject<Void, Never>()


    let brickLinkAPIClient: BrickLinkAPIClient
    let ordersStore: OrdersStore
    
    
    init() {
        
        let credentials = AppController.loadBrickLinkCredentials()
        self.brickLinkAPIClient = BrickLinkAPIClient(with: credentials)
        self.ordersStore = OrdersStore()
    }

    
    @discardableResult func loadOrders() -> AnyPublisher<Void, Never> {
        
        return Publishers.Future<Void, Never> { promise in
            
            _ = self.brickLinkAPIClient.getMyOrdersReceived()
            
                .sink { orders in
                    
                    self.ordersStore.orders = orders
                    
                    promise(.success(()))
                }
        }
        
        .eraseToAnyPublisher()
    }
    
    func createInventory(itemNo: String, completionHandler: @escaping () -> Void) {
        
        let timer = Timer(timeInterval: 2, repeats: false, block: { timer in
            completionHandler()
        })
        RunLoop.main.add(timer, forMode: .default)

        return
        
        let inventory = Inventory(
            
            item: InventoryItem(
                type: .part,
                no: itemNo
            ),
            colorId: .blue,
            quantity: 1,
            unitPrice: 0.24,
            newOrUsed: .used,
            isRetain: true,
            isStockRoom: true
        )
        
        _ = brickLinkAPIClient.create(inventory)
        
            .sink { createdInventory in
            
                print(createdInventory)
            
                completionHandler()
            }
    }
    
    
    static func loadBrickLinkCredentials() -> BrickLinkRequestCredentials {
        
        let url = Bundle.main.url(forResource: "BrickLinkCredentials", withExtension: "plist")!
        
        let data = try! Data(contentsOf: url)
        
        let credentials = try! PropertyListDecoder().decode(BrickLinkRequestCredentials.self, from: data)
        
        return credentials
    }
}
