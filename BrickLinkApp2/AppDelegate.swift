
import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let credentials = loadBrickLinkCredentials()
        
        let client = BrickLinkAPIClient(with: credentials)
        
        client.getMyOrdersReceived()
        
        return true
    }
    
    
    func loadBrickLinkCredentials() -> BrickLinkRequestCredentials {
        
        let url = Bundle.main.url(forResource: "BrickLinkCredentials", withExtension: "plist")!
        
        let data = try! Data(contentsOf: url)
        
        let credentials = try! PropertyListDecoder().decode(BrickLinkRequestCredentials.self, from: data)
        
        return credentials
    }
}
