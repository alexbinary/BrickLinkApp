
import Foundation


// MARK: - Main struct


struct OAuth1Authenticator {
    
    
    public func authenticate(_ request: URLRequest, with credentials: BrickLinkRequestCredentials) -> URLRequest {
        
        var authenticatedRequest = request
        
        let authorizationHeader = buildAuthorizationHeader(for: request, using: credentials)
        
        authenticatedRequest.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        
        return authenticatedRequest
    }
    
    
    
    func buildAuthorizationHeader(for request: URLRequest, using credentials: BrickLinkRequestCredentials) -> String {
        
        let oauthRequestParameters = OAuthRequestParameterSet(with: credentials)
        
        let signature = OAuthSignature(for: request, with: oauthRequestParameters, using: credentials)
        
        let encodedSignature = signature.rawValue.urlEncoded!
        
        return [
            
            "OAuth realm=\"\"",
            oauthRequestParameters.rawValues.map { $0+"=\""+($1.urlEncoded ?? $1)+"\"" } .joined(separator: ","),
            "oauth_signature=\"\(encodedSignature)\""
            
        ].joined(separator: ",")
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
