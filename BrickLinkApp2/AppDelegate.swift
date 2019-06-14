
import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let credentials = BrickLinkRequestCredentials(
            
            consumerKey: "5384025985CF43F391463885E5B033C6",
            consumerSecret: "F3F85C07C11642369B82B7339D965314",
            
            tokenValue: "13353D8AF9874BF1858064FD9454CDBF",
            tokenSecret: "1128A4EFCBCF46918E2AE818E26D5102"
        )
        
        let client = BrickLinkAPIClient(with: credentials)
        
        client.getMyOrdersReceived()
        
        return true
    }
}

