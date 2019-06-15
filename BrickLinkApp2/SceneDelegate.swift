//
//  SceneDelegate.swift
//  BrickLinkApp2
//
//  Created by Alexandre Bintz on 09/06/2019.
//  Copyright © 2019 Alexandre Bintz. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    
    lazy var credentials = loadBrickLinkCredentials()
    lazy var client = BrickLinkAPIClient(with: credentials)


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Use a UIHostingController as window root view controller
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.makeKeyAndVisible()
        
        loadOrders()
//        createInventory()
    }
    
    func loadOrders() {
        
        window!.rootViewController = UIHostingController(rootView: LoadingView(text: "Loading orders"))
        
        client.getMyOrdersReceived { orders in
            
            DispatchQueue.main.async {
                self.window!.rootViewController = UIHostingController(rootView: OrdersListView(orders: orders))
            }
        }
    }
    
    func createInventory() {
        
        window!.rootViewController = UIHostingController(rootView: LoadingView(text: "Creating inventory"))
        
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
        
        client.create(inventory) { createdInventory in
            
            print(createdInventory)
            
            DispatchQueue.main.async {
                self.window!.rootViewController = UIHostingController(rootView: LoadingView(text: "Inventory created"))
            }
        }
    }
    
    func loadBrickLinkCredentials() -> BrickLinkRequestCredentials {
        
        let url = Bundle.main.url(forResource: "BrickLinkCredentials", withExtension: "plist")!
        
        let data = try! Data(contentsOf: url)
        
        let credentials = try! PropertyListDecoder().decode(BrickLinkRequestCredentials.self, from: data)
        
        return credentials
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

