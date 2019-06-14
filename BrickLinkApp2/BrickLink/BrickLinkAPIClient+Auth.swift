
import Foundation



extension URLRequest {
    
    
    mutating func authenticate(with credentials: BrickLinkRequestCredentials) {
        
        let authorizationHeader = buildAuthorizationHeader(using: credentials)
        
        addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
    }
    
    
    func buildAuthorizationHeader(using credentials: BrickLinkRequestCredentials) -> String {
        
        let oauthRequestParameters = OAuthRequestParameterSet(with: credentials)
        
        let signature = OAuthSignature(for: self, with: oauthRequestParameters, using: credentials)
        
        let encodedSignature = signature.rawValue.urlEncoded!
        
        return [
            
            "OAuth realm=\"\"",
            oauthRequestParameters.rawValues.map { $0+"=\""+($1.urlEncoded ?? $1)+"\"" } .joined(separator: ","),
            "oauth_signature=\"\(encodedSignature)\""
            
        ].joined(separator: ",")
    }
}
