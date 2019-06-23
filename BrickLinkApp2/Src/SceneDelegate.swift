
import UIKit
import SwiftUI



class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = UIHostingController(rootView: MainView()
            .environmentObject(appController)
            .environmentObject(appController.ordersStore)
            .environmentObject(appController.colorsStore)
            .environmentObject(appController.inventoriesStore)
        )
        window!.makeKeyAndVisible()
        window?.tintColor = .systemYellow
        
        appController.loadOrders()
        appController.loadColors()
        appController.loadInventories()
    }
}
