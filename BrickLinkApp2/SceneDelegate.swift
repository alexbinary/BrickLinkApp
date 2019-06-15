
import UIKit
import SwiftUI



class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        
        let hvcOrders = UIHostingController(rootView: OrdersListView().environmentObject(appController.ordersStore))
        hvcOrders.tabBarItem.title = "Orders"
        
        let hvcInventory = UIHostingController(rootView: CreateInventoryView())
        hvcInventory.tabBarItem.title = "Inventory"
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            hvcOrders,
            hvcInventory
        ]
        
        window!.rootViewController = tabBarController
        
        appController.loadOrders { }
    }
}
