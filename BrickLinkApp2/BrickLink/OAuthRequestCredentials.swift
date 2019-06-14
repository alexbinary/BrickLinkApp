import Foundation



/// A set of value that identify and authenticate the issuer of an OAuth 1 request.
///
struct OAuthRequestCredentials {
    
    
    /// A key that identifies a client app to the service provider.
    ///
    /// Consumer keys are issued by the service provider and are unique to each app that access services from the provider.
    /// Contact your service provider to obtain a consumer key for your app.
    ///
    struct ConsumerKey {
        
        /// The key's raw string value.
        ///
        let rawValue: String
    }
    
    
    /// A secret that authenticates your app to the service provider.
    ///
    /// The secret is know only by your app and ensures that only it can access services from the provider using your consumer key.
    /// Secrets are usually issued by the service provider alongside the consumer key.
    ///
    struct ConsumerSecret {
        
        /// The secret's raw string value.
        ///
        let rawValue: String
    }
    
    
    /// A token used to grant specific access to your app on behalf of a specific user.
    ///
    /// Access tokens are usually issued by the service provider following interractions with the user to confirm that they want to give your app access to their data.
    /// Contact your sevice provider to know how you can obtain access tokens.
    ///
    struct AccessToken {
        
        /// The token's raw string value.
        ///
        let rawValue: String
    }
    
    
    /// A secret that makes sure only your app can use a given access token.
    ///
    /// Each access token is associated with a secret that only your app knows. Token secrets ensure that only your app can use a given access token.
    /// Token secrets are usually issued alongside access tokens.
    ///
    struct TokenSecret {
        
        /// The secret's raw string value.
        ///
        let rawValue: String
    }
    
    
    /// The key that identifies the app.
    ///
    let consumerKey: ConsumerKey
    
    /// The secret that authenticates the app to the service provider.
    ///
    let consumerSecret: ConsumerSecret
    
    
    /// The token that grants the app access to a user's data.
    ///
    let accessToken: AccessToken
    
    /// The secret associated with the access token.
    ///
    let tokenSecret: TokenSecret
    
    
    /// Creates a new set of credentials with the provided values.
    ///
    /// - Parameter consumerKey: The consumer key provided for your app by the service provider.
    /// - Parameter consumerSecret: The consumer secret provided by the service provider alongside your consumer key.
    ///
    /// - Parameter accessToken: The token that grants your app access to the user's data. Access tokens are usually issued by the service provider following interractions with the user to confirm that they want to give your app access to their data.
    /// - Parameter tokenSecret: The secret associated with the access token, usually issued alongside the access token.
    ///
    init(consumerKey: String, consumerSecret: String, accessToken: String, tokenSecret: String) {
        
        self.consumerKey = ConsumerKey(rawValue: consumerKey)
        self.consumerSecret = ConsumerSecret(rawValue: consumerSecret)
        self.accessToken = AccessToken(rawValue: accessToken)
        self.tokenSecret = TokenSecret(rawValue: tokenSecret)
    }
}
