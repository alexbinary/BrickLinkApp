
import Foundation



struct BrickLinkAPIClient {
    
    
    let credentials: BrickLinkRequestCredentials
    
    
    init(with credentials: BrickLinkRequestCredentials) {
        
        self.credentials = credentials
    }
    
    
    public func getMyOrdersReceived() {
        
        let url = URL(string: "https://api.bricklink.com/api/store/v1/orders?direction=in")!
        
        var request = URLRequest(url: url)
        
        request.authenticate(with: credentials)
        
        URLSession(configuration: .default).dataTask (with: request) { (data, response, error) in
            
            let httpResponse = response as! HTTPURLResponse
            
            print(httpResponse.statusCode)
            print(String(data: data!, encoding: .utf8)!)
            
        } .resume()
    }
}
