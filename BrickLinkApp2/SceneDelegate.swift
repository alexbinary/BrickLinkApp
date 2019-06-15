
import UIKit
import SwiftUI



class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        
        window!.rootViewController = UIHostingController(rootView: LoadingView(text: "Loading"))
        
        loadOrders()
    }
    
    func initView() {
        
        let hvcOrders = UIHostingController(rootView: OrdersListView(orders: appController.ordersStore.orders))
        hvcOrders.tabBarItem.title = "Orders"
        
        let hvcInventory = UIHostingController(rootView: CreateInventoryView())
        hvcInventory.tabBarItem.title = "Inventory"
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            hvcOrders,
            hvcInventory
        ]
        
        window!.rootViewController = tabBarController
    }
    
    func loadOrders() {
        
        appController.loadOrders {
            
            DispatchQueue.main.async {
                
                self.initView()
            }
        }
    }
}
