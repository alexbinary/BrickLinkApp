
import UIKit
import SwiftUI



class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.makeKeyAndVisible()
        
        loadOrders()
//        createInventory()
    }
    
    func loadOrders() {
        
        window!.rootViewController = UIHostingController(rootView: LoadingView(text: "Loading orders"))
        
        appController.loadOrders { orders in
            
            DispatchQueue.main.async {
                self.window!.rootViewController = UIHostingController(rootView: OrdersListView(orders: orders))
            }
        }
    }
    
    func createInventory() {
        
        window!.rootViewController = UIHostingController(rootView: LoadingView(text: "Creating inventory"))
        
        appController.createInventory { createdInventory in
            
            DispatchQueue.main.async {
                self.window!.rootViewController = UIHostingController(rootView: LoadingView(text: "Inventory created"))
            }
        }
    }
}
