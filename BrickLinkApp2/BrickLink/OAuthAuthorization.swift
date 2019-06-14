
import Foundation



struct OAuthAuthorization {
    
    
    let request: URLRequest
    let credentials: BrickLinkRequestCredentials
    let realm: String
    let oauthVersion: OAuthVersion
    let signatureMethod: OAuthSignatureMethod
    
    
    init(for request: URLRequest, using credentials: BrickLinkRequestCredentials, realm: String = "", oauthVersion: OAuthVersion = .v1_0, signatureMethod: OAuthSignatureMethod = .HMAC_SHA1) {
        
        self.request = request
        self.credentials = credentials
        self.realm = realm
        self.oauthVersion = oauthVersion
        self.signatureMethod = signatureMethod
    }
    

    /// Returns the value of the "Authorization" header to use to authenticate your request.
    ///
    /// The string is already encoded and ready to use as is.
    ///
    var stringForAuthorizationHeader: String {
        
        ""
    }
    
    
    /// Returns a string that you can use in the query part of the URL of your request.
    ///
    /// This property encodes the OAuth request parameters, including the signature, in a JSON object.
    ///
    /// Service providers usually expect this value to be provided in an "Authorization" parameter, e.g.:
    ///
    ///     https://example.com/?Authorization=<string>
    ///
    /// The string is already encoded so you can use it as is.
    ///
    var stringForQueryParameter: String {
        
        ""
    }
}
