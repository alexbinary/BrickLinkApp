
import Foundation
import CryptoSwift



extension URLRequest {
    
    
    mutating func authenticate(with credentials: BrickLinkRequestCredentials) {
        
        let authorizationHeader = buildAuthorizationHeader(using: credentials)
        
        addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
    }
    
    
    func buildAuthorizationHeader(using credentials: BrickLinkRequestCredentials) -> String {
        
        let oauthParameters = generateCompleteOAuthParameterSet(using: credentials)
        
        return "OAuth " + oauthParameters.map { $0 + "=" + $1.urlEncoded!.quoted } .joined(separator: ",")
    }
    
    
    func generateCompleteOAuthParameterSet(using credentials: BrickLinkRequestCredentials) -> [String: String] {
        
        let baseOAuthParameters = [
            
            "oauth_consumer_key":
                credentials.consumerKey,
            
            "oauth_token":
                credentials.tokenValue,
            
            "oauth_signature_method":
                "HMAC-SHA1",
            
            "oauth_timestamp":
                "\(Int(Date().timeIntervalSince1970)))",
            
            "oauth_nonce":
                UUID().uuidString,
            
            "oauth_version":
                "1.0",
        ]
        
        let requestParameters = collectRequestParameters()
        
        let parametersForSignature =
            
            baseOAuthParameters .merging(requestParameters, uniquingKeysWith: { (v1, v2) in v1 })
        
        let signature = generateSignature(using: parametersForSignature, with: credentials)
        
        return baseOAuthParameters.merging([
            
            "realm": "",
            "oauth_signature": signature
            
        ], uniquingKeysWith: { (v1, v2) in v1 })
    }
    
    
    func collectRequestParameters() -> [String: String] {
        
        var parameters: [String: String] = [:]
        
        URLComponents(url: self.url!, resolvingAgainstBaseURL: false)!
            
            .queryItems! .forEach { parameters[$0.name] = $0.value }
        
        return parameters
    }
    
    
    func generateSignature(using requestParameters: [String: String], with credentials: BrickLinkRequestCredentials) -> String {
        
        let signatureBaseString = buildSignatureBaseString(with: requestParameters)
        
        let signature = sign(signatureBaseString, with: credentials)
        
        return signature
    }
    
    
    func buildSignatureBaseString(with requestParameters: [String: String]) -> String {
        
        [
            httpMethod!.uppercased(),
            normalize(self.url!),
            normalize(requestParameters),
            
        ].map { $0.urlEncoded! } .joined(separator: "&")
    }
    
    
    func normalize(_ url: URL) -> String {
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        urlComponents.query = nil
        urlComponents.fragment = nil
        
        return urlComponents.url!.absoluteString
    }
    
    
    func normalize(_ requestParameters: [String: String]) -> String {
        
        let sorted = requestParameters.sorted { $0.key.compare($1.key) == .orderedAscending }
        
        let concatenated = sorted.map { $0.key + "=" + $0.value } .joined(separator: "&")
        
        return concatenated
    }
    
    
    func sign(_ signatureBaseString: String, with credentials: BrickLinkRequestCredentials) -> String {
        
        let key = buildSigningKey(from: credentials)
        
        let digest = try! HMAC(key: key, variant: .sha1).authenticate(signatureBaseString.bytes)
        
        return digest.toBase64()!
    }
    
    
    func buildSigningKey(from credentials: BrickLinkRequestCredentials) -> String {
        
        [ credentials.consumerSecret, credentials.tokenSecret ]
            
            .map { $0.urlEncoded! } .joined(separator: "&")
    }
}



extension String {
    
    
    var quoted: String {
        
        return "\"" + self + "\""
    }
    
    
    var urlEncoded: String? {
            
        self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"))
    }
}
