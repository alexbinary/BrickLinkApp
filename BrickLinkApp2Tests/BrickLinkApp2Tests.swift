
import XCTest
import CryptoSwift

@testable import BrickLinkApp2



class BrickLinkAuthenticationTests: XCTestCase {

    
    func testBrickLinkAuthentication() {
    
        var request = URLRequest(url: URL(string: "http://example.com?foo=bar")!)
        
        let credentials = BrickLinkCredentials(consumerKey: "azerty", consumerSecret: "uiop", tokenValue: "ytreza", tokenSecret: "poiu")

        request.addAuthentication(using: credentials)
        
        AuthenticationValidator().assertAuthenticationIsValid(for: request, using: credentials)
    }
}


struct AuthenticationValidator {
    
    
    func assertAuthenticationIsValid(for request: URLRequest, using credentials: BrickLinkCredentials) {
        
        let authorizationHeaderValue = request.value(forHTTPHeaderField: "Authorization")
        XCTAssertNotNil(authorizationHeaderValue, "Missing Authorization header")
        assertAuthorizationHeaderValueLooksValid(authorizationHeaderValue!)
        
        let oauthParameters = extractOAuthParameters(from: authorizationHeaderValue!)
        assertOAuthParametersAreValid(oauthParameters, using: credentials)
        
        let requestSignature = extractSignature(from: oauthParameters)
        let expectedSignature = generateSignature(for: request, with: oauthParameters, using: credentials)
        XCTAssertEqual(requestSignature, expectedSignature, "Invalid signature")
    }
    
    
    func assertAuthorizationHeaderValueLooksValid(_ authorizationHeaderValue: String) {
        
        XCTAssertTrue(
            authorizationHeaderValue.matches("^OAuth ([a-zA-Z0-9_]+=\"[^\"]*\")(,([a-zA-Z0-9_]+=\"[^\"]*\"))*$"),
            """
            Authorization header incorrect pattern: \(authorizationHeaderValue)
            Authorization header must start with "OAuth " then include one or more parameters separated by a comma (,), and nothing else after that.
            Each parameter must start with the parameter name without double quotes, then an equal sign (=), then the value between double quotes.
            """
        )
    }
    
    
    func assertOAuthParametersAreValid(_ oauthParameters: [String: String], using credentials: BrickLinkCredentials) {
        
        XCTAssertNotNil(oauthParameters["realm"], "Missing OAuth realm")
        XCTAssertEqual(oauthParameters["realm"]!, "", "Invalid OAuth realm")
        
        XCTAssertNotNil(oauthParameters["oauth_version"], "Missing OAuth version")
        XCTAssertEqual(oauthParameters["oauth_version"]!, "1.0", "Invalid OAuth version")
        
        XCTAssertNotNil(oauthParameters["oauth_signature_method"], "Missing signature method")
        XCTAssertEqual(oauthParameters["oauth_signature_method"]!, "HMAC-SHA1", "Invalid signature method")
        
        XCTAssertNotNil(oauthParameters["oauth_signature"], "Missing signature")
        XCTAssertNotEqual(oauthParameters["oauth_signature"]!, "", "Empty signature")
        
        XCTAssertNotNil(oauthParameters["oauth_timestamp"], "Missing timestamp")
        XCTAssertNotEqual(oauthParameters["oauth_timestamp"]!, "", "Empty timestamp")
        XCTAssertNotNil(Int(oauthParameters["oauth_timestamp"]!), "non numeric timestamp")
        
        XCTAssertNotNil(oauthParameters["oauth_nonce"], "Missing nonce")
        XCTAssertNotEqual(oauthParameters["oauth_nonce"]!, "", "Empty nonce")
        
        XCTAssertNotNil(oauthParameters["oauth_consumer_key"], "Missing consumer key")
        XCTAssertEqual(oauthParameters["oauth_consumer_key"]!, credentials.consumerKey, "Consumer key does not match credentials")
        
        XCTAssertNotNil(oauthParameters["oauth_token"], "Missing token")
        XCTAssertEqual(oauthParameters["oauth_token"]!, credentials.tokenValue, "Token does not match credentials")
    }
    
    
    func extractOAuthParameters(from authorizationHeaderValue: String) -> [String: String] {
        
        var oauthParameters = [String: String]()
        
        authorizationHeaderValue.split(separator: " ")[1].split(separator: ",").forEach { pair in
            
            let values = pair.split(separator: "=")
            
            let name = values[0].trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            
            let value = values[1].trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            
            oauthParameters[name] = value.removingPercentEncoding
        }
        
        return oauthParameters
    }
    
    
    func extractSignature(from oauthParameters: [String: String]) -> String {
        
        let signature = oauthParameters["oauth_signature"]!
        
        return signature
    }
    
    
    func generateSignature(for request: URLRequest, with oauthParameters: [String: String], using credentials: BrickLinkCredentials) -> String {
        
        let signatureBaseString = buildSignatureBaseString(for: request, with: oauthParameters)
        
        let key = buildSigningKey(from: credentials)
        
        let signature = sign(signatureBaseString, with: key)
        
        return signature
    }
    
    
    func buildSignatureBaseString(for request: URLRequest, with oauthParameters: [String: String]) -> String {
        
        var oauthParametersForSignature = oauthParameters
        
        oauthParametersForSignature.removeValue(forKey: "realm")
        oauthParametersForSignature.removeValue(forKey: "oauth_signature")
        
        let requestParameters = collectRequestParameters(from: request)
        
        let parametersForSignature = oauthParametersForSignature .merging(requestParameters, uniquingKeysWith: { (v1, v2) in v1 })
        
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


private extension String {
    
    
    var urlEncoded: String? {
        
        self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"))
    }
    
    
    var quoted: String {
        
        return "\"" + self + "\""
    }

    
    func matches(_ pattern: String) -> Bool {
        
        let inputRange = NSRange(self.startIndex..<self.endIndex, in: self)
        
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        return regex.matches(in: self, options: [], range: inputRange).count > 0
    }
}
