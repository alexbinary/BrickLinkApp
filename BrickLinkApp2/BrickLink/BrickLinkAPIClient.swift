
import Foundation



struct BrickLinkAPIClient {
    
    
    let credentials: BrickLinkRequestCredentials
    
    
    init(with credentials: BrickLinkRequestCredentials) {
        
        self.credentials = credentials
    }
    
    
    func getMyOrdersReceived(completionHandler: @escaping ([Order]) -> Void) {
        
        let url = URL(string: "https://api.bricklink.com/api/store/v1/orders?direction=in")!
        
        var request = URLRequest(url: url)
        
        request.authenticate(with: credentials)
        
        getResponse(for: request) { (response: APIResponse<[Order]>) in
            
            let orders = response.data
            
            completionHandler(orders)
        }
    }
    
    
    func create(_ inventory: Inventory, completionHandler: @escaping (Inventory) -> Void) {
        
        let url = URL(string: "https://api.bricklink.com/api/store/v1/inventories")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = Data(encodingAsJSON: inventory)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(String(data: request.httpBody!, encoding: .utf8)!)
        
        request.authenticate(with: credentials)
        
        getResponse(for: request) { (response: APIResponse<Inventory>) in
            
            let inventory = response.data
            
            completionHandler(inventory)
        }
    }
    
    
    func getResponse<T>(for request: URLRequest, completionHandler: @escaping (T) -> Void) where T: Decodable {
        
        URLSession(configuration: .default).dataTask (with: request) { (data, response, error) in
            
            print(String(data: data!, encoding: .utf8)!)
            
            completionHandler(data!.decode())
            
        } .resume()
    }
}


extension Data {
    
    init<T>(encodingAsJSON value: T) where T: Encodable {
    
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        self = try! encoder.encode(value)
    }
    
    func decode<T>() -> T where T: Decodable {
        
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        decoder.dateDecodingStrategy = .custom({ (decoder) in
            let stringValue = try! decoder.singleValueContainer().decode(String.self)
            return dateFormatter.date(from: stringValue)!
        })
        
        let decoded = try! decoder.decode(T.self, from: self)
        
        return decoded
    }
}
