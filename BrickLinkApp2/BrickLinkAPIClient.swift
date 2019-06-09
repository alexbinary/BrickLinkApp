
import Foundation
import CryptoSwift



/// An object that issues requests to the BrickLink webservice.
///
struct BrickLinkAPIClient {
    
    
    /// The root URL for all webservice endpoints.
    ///
    let brickLinkAPIBaseURL = URL(string: "https://api.bricklink.com/api/store/v1")!
    
    
    /// The default OAuth credentials to use to authenticate requests (provided by BrickLink).
    ///
    let brickLinkOAuthCredentials = OAuthCredentials(
    
        consumerKey: "5384025985CF43F391463885E5B033C6",
        consumerSecret: "1690FA35B37E49FBAF19542D5A02F9EA",
        
        accessToken: "1690FA35B37E49FBAF19542D5A02F9EA",
        tokenSecret: "FC274C6B460B4EB8BCFB22A41E6F1A01"
    )
    
    
    /// The direction of an order relative to a given user.
    ///
    /// Buyers can place orders, while sellers can received orders. A user can be a buyer and a seller at the
    /// same time, and thus can have orders of both types.
    ///
    enum OrderDirection {
        
        /// Indicates an order that is placed by a buyer to the user.
        ///
        case received
        
        /// Indicates an order that is placed by the user to a seller.
        ///
        case placed
    }
    
    
    /// Builds the URL to the user's orders of the specified direction.
    ///
    /// - Parameter direction: The direction of the orders to retrieve.
    ///
    /// - Returns: The full URL ready to use in a request.
    ///
    func brickLinkAPIURLForMyOrders(_ direction: OrderDirection) -> URL {
        
        switch direction {
            
            case .received:
                return brickLinkAPIBaseURL.appendingPathComponent("/orders?direction=in")
            
            case .placed:
                return brickLinkAPIBaseURL.appendingPathComponent("/orders?direction=out")
        }
    }
    
    
    /// HTTP methods, also called verbs.
    ///
    enum HTTPMethod: String {
        
        case GET
    }
    
    
    /// Creates an unauthenticated request to the specified URL with the specified HTTP method.
    ///
    /// - Parameter url: The target URL.
    /// - Parameter method: The HTTP method, defaults to GET.
    ///
    /// - Returns: The request.
    ///
    func createRequest(url: URL, method: String = "GET") -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        return request
    }
    
    
    /// Raw  value is the value of the request parameter.
    ///
    enum OAuthSignatureMethod: String {
        
        case HMAC_SHA1 = "HMAC-SHA1"
    }
    
    
    /// Raw  value is the value of the request parameter.
    ///
    enum OAuthVersion: String {
        
        case v1_0 = "1.0"
    }
    
    
    struct OAuth1RequestParameters {
        
        let version: OAuthVersion = .v1_0
        let signatureMethod: OAuthSignatureMethod = .HMAC_SHA1
        
        let timestamp = Date().timeIntervalSince1970
        let nonce = UUID().uuidString
        
        let realm = ""
        
        let consumerKey: OAuthCredentials.ConsumerKey
        let accessToken: OAuthCredentials.AccessToken
        
        
        init(consumerKey: OAuthCredentials.ConsumerKey, accessToken: OAuthCredentials.AccessToken) {
            
            self.consumerKey = consumerKey
            self.accessToken = accessToken
        }
        
        init(with credentials: OAuthCredentials) {
            
            self.init(consumerKey: credentials.consumerKey, accessToken: credentials.accessToken)
        }
        
        
        var requestParametersForOAuth1SignatureBaseString: [String: String] { [
            
            "oauth_consumer_key": consumerKey.rawValue,
            "oauth_token": accessToken.rawValue,
            "oauth_signature_method": signatureMethod.rawValue,
            "oauth_timestamp": "\(timestamp)",
            "oauth_nonce": nonce,
            "oauth_version": version.rawValue,
        ] }
        
        
        var valuesForAuthorizationHeader: [String: String] { [
            
            "realm": realm,
            "oauth_consumer_key": consumerKey.rawValue,
            "oauth_token": accessToken.rawValue,
            "oauth_signature_method": signatureMethod.rawValue,
            "oauth_timestamp": "\(timestamp)",
            "oauth_nonce": nonce,
            "oauth_version": version.rawValue,
        ] }
    }
    
    
    func collectRequestParametersForOAuth1SignatureBaseString(for request: URLRequest, with oauthParameters: OAuth1RequestParameters) -> [String: String] {
        
        var requestParameters: [String: String] = [:]
            
        requestParameters.merge(request.requestParametersForOAuth1SignatureBaseString, uniquingKeysWith: { (k1, k2) in k1 })
        
        requestParameters.merge(oauthParameters.requestParametersForOAuth1SignatureBaseString, uniquingKeysWith: { (k1, k2) in k1 })
        
        return requestParameters
    }
    
    
    func normalizeRequestParametersForOAuth1SignatureBaseString(_ parameters: [String: String]) -> String {
        
        let sorted = parameters.sorted { $0.key.compare($1.key) == .orderedAscending }
        
        let concatenated = sorted.map { "\($0.key)=\($0.value)" } .joined(separator: "&")
        
        return concatenated
    }
    
    
    func buildOAuth1SignatureBaseString(_ request: URLRequest, _ normalizedRequestParameters: String) -> String {
        
        guard let httpMethod = request.httpMethod else {
            
            fatalError("Could not get request HTTP method")
        }
        
        guard let url = request.url else {
            
            fatalError("Could not get request URL")
        }
        
        let urlForSignatureBaseString = url.urlForOAuth1SignatureBaseString
        
        let elements = [
            
            httpMethod.uppercased(),
            urlForSignatureBaseString,
            normalizedRequestParameters,
        ]
        
        let signatureBaseString = elements.map { $0.urlEncoded } .joined(separator: "&")
        
        return signatureBaseString
    }
    
    
    func buildOAuth1Signature(from signatureBaseString: String, using credentials: OAuthCredentials) -> String {
        
        let key = [credentials.consumerSecret.rawValue, credentials.tokenSecret.rawValue] .map { $0.urlEncoded } .joined(separator: "&")
        
        guard let digest = try? HMAC(key: key, variant: .sha1).authenticate(signatureBaseString.bytes) else {
            
            fatalError("HMAC encoding failed")
        }
        
        guard let base64EncodedDigest = digest.toBase64() else {
            
            fatalError("base 64 encoding failed")
        }
        
        return base64EncodedDigest
    }
    
    
    func buildOAuth1AuthorizationHeader(_ requestParameters: OAuth1RequestParameters, _ signature: String) -> String {
        
        return """
            OAuth \
            \(requestParameters.valuesForAuthorizationHeader.map { "\($0)=\"\($1.urlEncoded)\"" } .joined(separator: ",")),\
            oauth_signature="\(signature)"
            """
    }
    
    
    func authenticate(_ request: URLRequest, with credentials: OAuthCredentials) -> URLRequest {
        
        let oauthRequestParameters = OAuth1RequestParameters(with: credentials)
        
        let oauthSignatureBaseStringRequestParameters = collectRequestParametersForOAuth1SignatureBaseString(for: request, with: oauthRequestParameters)
        
        let normalizedRequestParametersForSignatureBaseString = normalizeRequestParametersForOAuth1SignatureBaseString(oauthSignatureBaseStringRequestParameters)
        
        let oauthSignatureBaseString = buildOAuth1SignatureBaseString(request, normalizedRequestParametersForSignatureBaseString)
        
        let oauthSignature = buildOAuth1Signature(from: oauthSignatureBaseString, using: credentials)
        
        let authorizationHeader = buildOAuth1AuthorizationHeader(oauthRequestParameters, oauthSignature)
        
        var authenticatedRequest = request

        authenticatedRequest.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        
        return authenticatedRequest
    }
    
    
    func execute(_ request: URLRequest) {
        
        URLSession(configuration: .default).dataTask (with: request) { (data, response, error) in
            
            let httpResponse = response as! HTTPURLResponse
            
            print(httpResponse.statusCode)
            print(String(data: data!, encoding: .utf8)!)
            
        } .resume()
    }
    
    
    public func getMyOrdersReceived() {
        
        let endPointURL = brickLinkAPIURLForMyOrders(.received)
        
        let request = createRequest(url: endPointURL)
        
        let authenticatedRequest = authenticate(request, with: brickLinkOAuthCredentials)
        
        execute(authenticatedRequest)
    }
}




extension URLRequest {
    
    
    var requestParametersForOAuth1SignatureBaseString: [String: String] {
        
        var requestParameters: [String: String] = [:]
        
        guard let url = self.url else {
            
            fatalError("Could not get request URL")
        }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            
            fatalError("Could not extract URL components")
        }
        
        if let queryItems = components.queryItems {
            
            queryItems.forEach { requestParameters[$0.name] = $0.value }
        }
        
        return requestParameters
    }
    
    
    var urlForOAuth1SignatureBaseString: String {
        
        guard let url = self.url else {
            
            fatalError("Could not get request URL")
        }
        
        return url.urlForOAuth1SignatureBaseString
    }
}



extension URL {
    
    
    var urlForOAuth1SignatureBaseString: String {
        
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            
            fatalError("Could not extract URL components")
        }
        
        urlComponents.query = nil
        urlComponents.fragment = nil
        
        guard let url = urlComponents.url else {
            
            fatalError("Could not build URL from components")
        }
        
        return url.absoluteString
    }
}



extension String {
    
    
    var urlEncoded: String {
        
        guard let encoded = self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")) else {
            
            fatalError("Encoding failed")
        }
        
        return encoded
    }
}
