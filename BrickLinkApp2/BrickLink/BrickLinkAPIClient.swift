
import Foundation



struct BrickLinkAPIClient {
    
    
    let credentials = BrickLinkRequestCredentials(
    
        consumerKey: "5384025985CF43F391463885E5B033C6",
        consumerSecret: "F3F85C07C11642369B82B7339D965314",
        
        tokenValue: "13353D8AF9874BF1858064FD9454CDBF",
        tokenSecret: "1128A4EFCBCF46918E2AE818E26D5102"
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
