
import Foundation



struct AppController {


    let brickLinkAPIClient: BrickLinkAPIClient
    
    
    init() {
        
        let credentials = AppController.loadBrickLinkCredentials()
        self.brickLinkAPIClient = BrickLinkAPIClient(with: credentials)
    }

    
    func loadOrders(completionHandler: @escaping ([Order]) -> Void) {
        
        brickLinkAPIClient.getMyOrdersReceived { orders in
            
            completionHandler(orders)
        }
    }
    
    func createInventory(completionHandler: @escaping (Inventory) -> Void) {
        
        let inventory = Inventory(
            
            item: InventoryItem(
                type: .part,
                no: "93274"
            ),
            colorId: .blue,
            quantity: 1,
            unitPrice: 0.24,
            newOrUsed: .used,
            isRetain: true,
            isStockRoom: true
        )
        
        brickLinkAPIClient.create(inventory) { createdInventory in
            
            completionHandler(createdInventory)
        }
    }
    
    
    static func loadBrickLinkCredentials() -> BrickLinkRequestCredentials {
        
        let url = Bundle.main.url(forResource: "BrickLinkCredentials", withExtension: "plist")!
        
        let data = try! Data(contentsOf: url)
        
        let credentials = try! PropertyListDecoder().decode(BrickLinkRequestCredentials.self, from: data)
        
        return credentials
    }
}
