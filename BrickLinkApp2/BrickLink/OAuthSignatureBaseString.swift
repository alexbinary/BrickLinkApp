
import Foundation



struct OAuthSignatureBaseString {
    
    
    static func collectRequestParametersForOAuth1SignatureBaseString(for request: URLRequest, with oauthParameters: OAuthRequestParameterSet) -> [String: String] {
        
        var requestParameters: [String: String] = [:]
        
        requestParameters.merge(request.requestParametersForSignatureBaseString, uniquingKeysWith: { (k1, k2) in k1 })
        
        requestParameters.merge(oauthParameters.rawValues, uniquingKeysWith: { (k1, k2) in k1 })
        
        return requestParameters
    }
    
    
    static func normalizeRequestParametersForOAuth1SignatureBaseString(_ parameters: [String: String]) -> String {
        
        let sorted = parameters.sorted { $0.key.compare($1.key) == .orderedAscending }
        
        let concatenated = sorted.map { "\($0.key)=\($0.value)" } .joined(separator: "&")
        
        return concatenated
    }
    
    
    static func buildOAuth1SignatureBaseString(_ request: URLRequest, _ normalizedRequestParameters: String) -> String {
        
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
    
    
    init(for request: URLRequest, with oauthParameters: OAuthRequestParameterSet) {
        
        let requestParametersForSignatureBaseString = OAuthSignatureBaseString.collectRequestParametersForOAuth1SignatureBaseString(for: request, with: oauthParameters)
        
        let normalizedRequestParametersForSignatureBaseString = OAuthSignatureBaseString.normalizeRequestParametersForOAuth1SignatureBaseString(requestParametersForSignatureBaseString)
        
        self.rawValue = OAuthSignatureBaseString.buildOAuth1SignatureBaseString(request, normalizedRequestParametersForSignatureBaseString)
        
    }
    
    
    public let rawValue: String
    
}
