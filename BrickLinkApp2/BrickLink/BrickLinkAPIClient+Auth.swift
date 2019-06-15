
import Foundation
import CryptoSwift



/// See http://apidev.bricklink.com/redmine/projects/bricklink-api/wiki/Authorization
/// See https://oauth.net/core/1.0/



extension URLRequest {
    
    
    mutating func authenticate(with credentials: BrickLinkRequestCredentials) {
        
        let authorizationHeader = buildAuthorizationHeader(using: credentials)
        
        addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
    }
    
    
    func buildAuthorizationHeader(using credentials: BrickLinkRequestCredentials) -> String {
        
        let oauthParameters = generateCompleteOAuthParameterSet(using: credentials)
        
        let headerValue = "OAuth " + oauthParameters.map { $0 + "=" + $1.urlEncoded!.quoted } .joined(separator: ",")
        
        return headerValue
    }
    
    
    func generateCompleteOAuthParameterSet(using credentials: BrickLinkRequestCredentials) -> [String: String] {
        
        let baseParameterSet = [
            
            "oauth_consumer_key":
                credentials.consumerKey,
            
            "oauth_token":
                credentials.tokenValue,
            
            "oauth_signature_method":
                "HMAC-SHA1",
            
            "oauth_timestamp":
                "\(Int(Date().timeIntervalSince1970))",
            
            "oauth_nonce":
                UUID().uuidString,
            
            "oauth_version":
                "1.0",
        ]
        
        let signature = generateSignature(using: baseParameterSet, with: credentials)
        
        let completeOAuthParameterSet = baseParameterSet.merging([
            
            "realm": "",
            "oauth_signature": signature
            
        ], uniquingKeysWith: { (v1, v2) in v1 })
        
        return completeOAuthParameterSet
    }
    
    
    func generateSignature(using oauthParameters: [String: String], with credentials: BrickLinkRequestCredentials) -> String {
        
        let signatureBaseString = buildSignatureBaseString(with: oauthParameters)
        
        let key = buildSigningKey(from: credentials)
        
        let digest = try! HMAC(key: key, variant: .sha1).authenticate(signatureBaseString.bytes)
        
        let signature = digest.toBase64()!
        
        return signature
    }
    
    
    func buildSignatureBaseString(with oauthParameters: [String: String]) -> String {
        
        let requestParameters = collectRequestParameters()
        
        let parametersForSignature =
            
            oauthParameters .merging(requestParameters, uniquingKeysWith: { (v1, v2) in v1 })
        
        let elements = [
            
            httpMethod!.uppercased(),
            normalize(self.url!),
            normalize(parametersForSignature),
        ]
        
        let signatureBaseString = elements .map { $0.urlEncoded! } .joined(separator: "&")
        
        return signatureBaseString
    }
    
    
    func collectRequestParameters() -> [String: String] {
        
        var parameters: [String: String] = [:]
        
        URLComponents(url: self.url!, resolvingAgainstBaseURL: false)!
            
            .queryItems? .forEach { parameters[$0.name] = $0.value }
        
        return parameters
    }
    
    
    func normalize(_ url: URL) -> String {
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        urlComponents.query = nil
        urlComponents.fragment = nil
        
        let normalizedUrl = urlComponents.url!.absoluteString
        
        return normalizedUrl
    }
    
    
    func normalize(_ requestParameters: [String: String]) -> String {
        
        let sorted = requestParameters.sorted { $0.key.compare($1.key) == .orderedAscending }
        
        let concatenated = sorted.map { $0.key + "=" + $0.value.urlEncoded! } .joined(separator: "&")
        
        return concatenated
    }
    
    
    func buildSigningKey(from credentials: BrickLinkRequestCredentials) -> String {
        
        let key = [ credentials.consumerSecret, credentials.tokenSecret ]
            
            .map { $0.urlEncoded! } .joined(separator: "&")
        
        return key
    }
}



extension String {
    
    
    /// See https://oauth.net/core/1.0/#rfc.section.5.1
    ///
    var urlEncoded: String? {
            
        self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"))
    }
    
    
    var quoted: String {
        
        return "\"" + self + "\""
    }
}
