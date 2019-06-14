
import Foundation
import CryptoSwift



struct OAuthSignature {
    
    
    init(for request: URLRequest, with oauthRequestParameters: OAuthRequestParameterSet, using credentials: BrickLinkRequestCredentials) {
        
        let oauthSignatureBaseString = OAuthSignatureBaseString(for: request, with: oauthRequestParameters)
        
        self.rawValue = OAuthSignature.buildOAuth1Signature(from: oauthSignatureBaseString.rawValue, using: credentials)
    }
    
    
    
    static func buildOAuth1Signature(from signatureBaseString: String, using credentials: BrickLinkRequestCredentials) -> String {
        
        let key = [credentials.consumerSecret, credentials.tokenSecret] .map { $0.urlEncoded! } .joined(separator: "&")
        
        guard let digest = try? HMAC(key: key, variant: .sha1).authenticate(signatureBaseString.bytes) else {
            
            fatalError("HMAC encoding failed")
        }
        
        guard let base64EncodedDigest = digest.toBase64() else {
            
            fatalError("base 64 encoding failed")
        }
        
        return base64EncodedDigest
    }
    
    
    
    
    
    
    
    
    
    
    
    public let rawValue: String
}
