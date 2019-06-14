
import Foundation



struct BrickLinkAPIClient {
    
    
    /// The root URL for all webservice endpoints.
    ///
    let brickLinkAPIBaseURL = URL(string: "https://api.bricklink.com/api/store/v1")!
    
    
    let requestCredentials = BrickLinkRequestCredentials(
    
        consumerKey: "5384025985CF43F391463885E5B033C6",
        consumerSecret: "1690FA35B37E49FBAF19542D5A02F9EA",
        
        tokenValue: "1690FA35B37E49FBAF19542D5A02F9EA",
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
        
        return brickLinkAPIBaseURL.appendingPathComponent("/orders")
        
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
        
        let authenticatedRequest = OAuth1Authenticator().authenticate(request, with: requestCredentials)
        
        execute(authenticatedRequest)
    }
}


