
import Foundation



struct BrickLinkRequestCredentials: Decodable {
    
    let consumerKey: String
    let consumerSecret: String
    
    let tokenValue: String
    let tokenSecret: String
}
