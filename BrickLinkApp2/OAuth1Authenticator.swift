
import Foundation
import CryptoSwift


// MARK: - Main struct


struct OAuth1Authenticator {
    
    
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
        
        let timestamp = Int(Date().timeIntervalSince1970)
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
        
        requestParameters.merge(request.requestParametersForSignatureBaseString, uniquingKeysWith: { (k1, k2) in k1 })
        
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
        
        let urlForSignatureBaseString = url.urlForSignatureBaseString!
        
        let elements = [
            
            httpMethod.uppercased(),
            urlForSignatureBaseString,
            normalizedRequestParameters,
        ]
        
        let signatureBaseString = elements.map { $0.urlEncoded! } .joined(separator: "&")
        
        return signatureBaseString
    }
    
    
    func buildOAuth1Signature(from signatureBaseString: String, using credentials: OAuthCredentials) -> String {
        
        let key = [credentials.consumerSecret.rawValue, credentials.tokenSecret.rawValue] .map { $0.urlEncoded! } .joined(separator: "&")
        
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
    
    
    public func authenticate(_ request: URLRequest, with credentials: OAuthCredentials) -> URLRequest {
        
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
}

// MARK: - Extensions



extension URLRequest {
    
    
    /// Returns the query and POST parameters of the request that should be included in the Signature Base String.
    ///
    /// Form data are not supported at the moment. Only query parameters are included.
    ///
    /// ## Reference
    ///
    /// - [OAuth1 spec](https://oauth.net/core/1.0/#rfc.section.9.1.1)
    ///   > "The request parameters are [...]:
    ///   > - (...))
    ///   > - Parameters in the HTTP POST request body (with a content-type of application/x-www-form-urlencoded).
    ///   > - HTTP GET parameters added to the URLs in the query part (as defined by RFC3986 section 3)."
    ///
    /// # See also
    ///
    /// - [RFC3986 section 3](https://tools.ietf.org/html/rfc3986#section-3)
    ///
    var requestParametersForSignatureBaseString: [String: String] {
        
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
    
    
    /// Returns a string representing the URL of the request that is suited to be included in the Signature Base String.
    ///
    /// The returned URL includes the scheme, authority, and path, and excludes the query and fragment.
    ///
    /// ## Reference
    ///
    /// - [OAuth1 spec](https://oauth.net/core/1.0/#rfc.section.9.1.2)
    ///   > "The URL used in the Signature Base String MUST include the scheme, authority, and path, and MUST exclude the query and fragment as defined by RFC3986 section 3."
    ///
    /// # See also
    ///
    /// - [RFC3986 section 3](https://tools.ietf.org/html/rfc3986#section-2.3)
    ///
    var urlForSignatureBaseString: String? {
        
        guard let url = self.url else {
            
            print("\(#file) \(#function) Could not get URL from request: \(self)")
            return nil
        }
        
        return url.urlForSignatureBaseString
    }
}



extension URL {
    
    
    /// Returns a string representing the URL that is suited to be included in the Signature Base String.
    ///
    /// The returned URL includes the scheme, authority, and path, and excludes the query and fragment.
    ///
    /// ## Reference
    ///
    /// - [OAuth1 spec](https://oauth.net/core/1.0/#rfc.section.9.1.2)
    ///   > "The URL used in the Signature Base String MUST include the scheme, authority, and path, and MUST exclude the query and fragment as defined by RFC3986 section 3."
    ///
    /// # See also
    ///
    /// - [RFC3986 section 3](https://tools.ietf.org/html/rfc3986#section-2.3) for the full RFC.
    ///
    var urlForSignatureBaseString: String? {
        
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            
            print("\(#file) \(#function) Failed to get URL components from url: \(self.absoluteString)")
            return nil
        }
        
        urlComponents.query = nil
        urlComponents.fragment = nil
        
        guard let url = urlComponents.url else {
            
            print("\(#file) \(#function) Failed to construct URL from components: \(urlComponents)")
            return nil
        }
        
        return url.absoluteString
    }
}



extension String {
    
    
    /// Returns a new string created by replacing characters in the string with percent encoded characters in compliance with the OAuth1 spec.
    ///
    /// All non-alphanumeric characters except -_.~ are replaced with the corresponding percent encoded characters.
    ///
    /// ## Reference
    ///
    /// - [OAuth1 spec](https://oauth.net/core/1.0/#rfc.section.5.1)
    ///   > "Characters not in the unreserved character set (RFC3986 section 2.3) MUST be encoded. Characters in the unreserved character set MUST NOT be encoded."
    ///
    /// - [RFC3986 section 2.3](https://tools.ietf.org/html/rfc3986#section-2.3)
    ///   > "`unreserved  = ALPHA / DIGIT / "-" / "." / "_" / "~"`"
    ///
    var urlEncoded: String? {
        
        self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"))
    }
}
