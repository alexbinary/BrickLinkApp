
import Foundation
import SwiftUI
import Combine



class AppController: BindableObject {
    
    
    let didChange = PassthroughSubject<Void, Never>()


    let brickLinkAPIClient: BrickLinkAPIClient
    
    let ordersStore: OrdersStore
    let colorsStore: ColorsStore
    
    
    init() {
        
        let credentials = AppController.loadBrickLinkCredentials()
        self.brickLinkAPIClient = BrickLinkAPIClient(with: credentials)
        self.ordersStore = OrdersStore()
        self.colorsStore = ColorsStore()
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
    
    
    @discardableResult func loadColors() -> AnyPublisher<Void, Never> {
        
        return Publishers.Future<Void, Never> { promise in
            
            _ = self.brickLinkAPIClient.getColorList()
                
                .sink { colors in
                    
                    self.colorsStore.colors = colors
                    
                    promise(.success(()))
                }
        }
        
        .eraseToAnyPublisher()
    }
    
    
    @discardableResult func getPriceGuide(itemNo: String, colorId: Int) -> AnyPublisher<PriceGuide, Never> {
        
        return self.brickLinkAPIClient.getPriceGuide(itemNo: itemNo, colorId: colorId)
    }
    
    
    @discardableResult func create(_ inventory: Inventory, _ autoPrice: Bool) -> AnyPublisher<Void, Never> {
        
        print(inventory)

        return Publishers.Future<Void, Never> { promise in

            let timer = Timer(timeInterval: 2, repeats: false, block: { timer in
                promise(.success(()))
            })
            RunLoop.main.add(timer, forMode: .default)
        }

        .eraseToAnyPublisher()
        
        return Publishers.Future<Void, Never> { promise in
            
            _ = self.brickLinkAPIClient.getPriceGuide(itemNo: inventory.item.no, colorId: inventory.colorId)
                
                .sink { priceGuide in
                    
                    var inv = inventory
                    
                    if autoPrice {
                    
                        inv.unitPrice = priceGuide.avgPrice
                    }
                    
                    print(inv)
                    
                    _ = self.brickLinkAPIClient.create(inv)
                        
                        .sink { createdInventory in
                            
                            print(createdInventory)
                            
                            promise(.success(()))
                        }
                }
        }
        
        .eraseToAnyPublisher()
    }
    
    
    static func loadBrickLinkCredentials() -> BrickLinkRequestCredentials {
        
        let url = Bundle.main.url(forResource: "BrickLinkCredentials", withExtension: "plist")!
        
        let data = try! Data(contentsOf: url)
        
        let credentials = try! PropertyListDecoder().decode(BrickLinkRequestCredentials.self, from: data)
        
        return credentials
    }
}
