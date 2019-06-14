
import Foundation



struct OAuthRequestParameterSet {
    
    
    
    
    
    let version: OAuthVersion = .v1_0
    let signatureMethod: OAuthSignatureMethod = .HMAC_SHA1
    
    let timestamp = Int(Date().timeIntervalSince1970)
    let nonce = UUID().uuidString
    
    let consumerKey: String
    let accessToken: String
    
    
    init(with credentials: BrickLinkRequestCredentials) {
    
        self.consumerKey = credentials.consumerKey
        self.accessToken = credentials.tokenValue
    }
    
    
    var rawValues: [String: String] { [
        
        "oauth_consumer_key": consumerKey,
        "oauth_token": accessToken,
        "oauth_signature_method": signatureMethod.rawValue,
        "oauth_timestamp": "\(timestamp)",
        "oauth_nonce": nonce,
        "oauth_version": version.rawValue,
    ] }
}




/// Raw value is the value of the request parameter.
///
enum OAuthSignatureMethod: String {
    
    case HMAC_SHA1 = "HMAC-SHA1"
}


/// Raw value is the value of the request parameter.
///
enum OAuthVersion: String {
    
    case v1_0 = "1.0"
}
