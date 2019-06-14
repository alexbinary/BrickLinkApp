
import Foundation



struct BrickLinkAPIClient {
    
    
    let credentials = BrickLinkRequestCredentials(
    
        consumerKey: "5384025985CF43F391463885E5B033C6",
        consumerSecret: "1690FA35B37E49FBAF19542D5A02F9EA",
        
        tokenValue: "1690FA35B37E49FBAF19542D5A02F9EA",
        tokenSecret: "FC274C6B460B4EB8BCFB22A41E6F1A01"
    )
    
    
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
