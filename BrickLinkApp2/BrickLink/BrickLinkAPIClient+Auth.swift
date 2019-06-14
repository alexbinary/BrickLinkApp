
import Foundation



extension URLRequest {
    
    
    mutating func authenticate(with credentials: BrickLinkRequestCredentials) {
        
        self = OAuth1Authenticator().authenticate(self, with: credentials)
    }
}
