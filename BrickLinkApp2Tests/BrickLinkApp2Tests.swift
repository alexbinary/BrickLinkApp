
import XCTest
import CryptoSwift

@testable import BrickLinkApp2



class BrickLinkAuthenticationTests: XCTestCase {

    
    func testBrickLinkAuthentication() {
    
        var request = URLRequest(url: URL(string: "http://example.com?foo=bar")!)
        
        let credentials = BrickLinkCredentials(consumerKey: "azerty", consumerSecret: "uiop", tokenValue: "ytreza", tokenSecret: "poiu")

        request.addAuthentication(using: credentials)
        
        let authenticationValid = AuthenticationValidator().validateAuthentication(of: request, using: credentials)
        
        XCTAssertTrue(authenticationValid, "Request signature invalid")
    }
}


struct AuthenticationValidator {
    
    
    func validateAuthentication(of request: URLRequest, using credentials: BrickLinkCredentials) -> Bool {
        
        guard validateOAuthParameters(from: request, using: credentials) else {
            return false
        }
        
        let requestSignature = extractSignature(from: request)
        let expectedSignature = generateSignature(for: request, using: credentials)
        
        guard requestSignature == expectedSignature else {
            return false
        }
        
        return true
    }
    
    
    func validateOAuthParameters(from request: URLRequest, using credentials: BrickLinkCredentials) -> Bool {
        
        let oauthParameters = extractOAuthParameters(from: request)
        
        guard oauthParameters["realm"] == "" else {
            return false
        }
        
        guard oauthParameters["oauth_version"] == "1.0" else {
            return false
        }
        
        guard oauthParameters["oauth_timestamp"] != nil else {
            return false
        }
        
        guard oauthParameters["oauth_nonce"] != nil else {
            return false
        }
        
        guard oauthParameters["oauth_consumer_key"] == credentials.consumerKey else {
            return false
        }
        
        guard oauthParameters["oauth_token"] == credentials.tokenValue else {
            return false
        }
        
        guard oauthParameters["oauth_signature_method"] == "HMAC-SHA1" else {
            return false
        }
        
        return true
    }
    
    
    func extractSignature(from request: URLRequest) -> String {
        
        let oauthParameters = extractOAuthParameters(from: request)
        
        let signature = oauthParameters["oauth_signature"]!
        
        return signature
    }
    
    
    func extractOAuthParameters(from request: URLRequest) -> [String: String] {
        
        let authorization = request.value(forHTTPHeaderField: "Authorization")!
        
        var oauthParameters = [String: String]()
        
        authorization.split(separator: " ")[1].split(separator: ",").forEach { pair in
            
            let values = pair.split(separator: "=")
            
            let name = values[0].trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            
            let value = values[1].trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            
            oauthParameters[name] = value.removingPercentEncoding
        }
        
        return oauthParameters
    }
    
    
    func generateSignature(for request: URLRequest, using credentials: BrickLinkCredentials) -> String {
        
        let signatureBaseString = buildSignatureBaseString(for: request)
        
        let key = buildSigningKey(from: credentials)
        
        let signature = sign(signatureBaseString, with: key)
        
        return signature
    }
    
    
    func buildSignatureBaseString(for request: URLRequest) -> String {
        
        var oauthParameters = extractOAuthParameters(from: request)
        
        oauthParameters.removeValue(forKey: "realm")
        oauthParameters.removeValue(forKey: "oauth_signature")
        
        let requestParameters = collectRequestParameters(from: request)
        
        let parametersForSignature = oauthParameters .merging(requestParameters, uniquingKeysWith: { (v1, v2) in v1 })
        
        let elements = [
            
            request.httpMethod!.uppercased(),
            normalize(request.url!),
            normalize(parametersForSignature),
        ]
        
        let signatureBaseString = elements .map { $0.urlEncoded! } .joined(separator: "&")
        
        return signatureBaseString
    }
    
    
    func collectRequestParameters(from request: URLRequest) -> [String: String] {
        
        var parameters: [String: String] = [:]
        
        URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!
            
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
        
        let sorted = requestParameters .sorted { $0.key.compare($1.key) == .orderedAscending }
        
        let concatenated = sorted .map { $0.key + "=" + $0.value.urlEncoded! } .joined(separator: "&")
        
        return concatenated
    }
    
    
    func buildSigningKey(from credentials: BrickLinkCredentials) -> String {
        
        let key = [ credentials.consumerSecret, credentials.tokenSecret ]
            
            .map { $0.urlEncoded! } .joined(separator: "&")
        
        return key
    }
    
    
    func sign(_ signatureBaseString: String, with key: String) -> String {
        
        let digest = try! HMAC(key: key, variant: .sha1).authenticate(signatureBaseString.bytes)
        
        let signature = digest.toBase64()!
        
        return signature
    }
}
