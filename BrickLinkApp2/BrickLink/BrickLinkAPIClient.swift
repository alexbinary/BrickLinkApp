
import Foundation
import Combine



struct BrickLinkAPIClient {
    
    
    let credentials: BrickLinkRequestCredentials
    
    
    init(with credentials: BrickLinkRequestCredentials) {
        
        self.credentials = credentials
    }
    
    
    func getMyOrdersReceived() -> AnyPublisher<[Order], Never> {
        
        let url = URL(string: "https://api.bricklink.com/api/store/v1/orders?direction=in")!
        
        var request = URLRequest(url: url)
        
        request.authenticate(with: credentials)
        
        return getResponse(for: request)
        
            .map { (response: APIResponse<[Order]>) in
            
                let orders = response.data
                
                return orders
            }
        
            .eraseToAnyPublisher()
    }
    
    
    func create(_ inventory: Inventory) -> AnyPublisher<Inventory, Never> {
        
        let url = URL(string: "https://api.bricklink.com/api/store/v1/inventories")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = Data(encodingAsJSON: inventory)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(String(data: request.httpBody!, encoding: .utf8)!)
        
        request.authenticate(with: credentials)
        
        return getResponse(for: request)
        
            .map { (response: APIResponse<Inventory>) in
                
                let inventory = response.data
                
                return inventory
            }
            
            .eraseToAnyPublisher()
    }
    
    
    func getPriceGuide(itemNo: String, colorId: Int) -> AnyPublisher<PriceGuide, Never> {
        
        let url = URL(string: "https://api.bricklink.com/api/store/v1/items/PART/\(itemNo)/price?color_id=\(colorId)&guide_type=sold&new_or_used=U&currency_code=EUR")!
        
        var request = URLRequest(url: url)
        
        request.authenticate(with: credentials)
        
        return getResponse(for: request)
            
            .map { (response: APIResponse<PriceGuide>) in
                
                let priceGuide = response.data
                
                return priceGuide
            }
            
            .eraseToAnyPublisher()
    }
    
    
    func getColorList() -> AnyPublisher<[BrickLinkColor], Never> {
        
        let url = URL(string: "https://api.bricklink.com/api/store/v1/colors")!
        
        var request = URLRequest(url: url)
        
        request.authenticate(with: credentials)
        
        return getResponse(for: request)
            
            .map { (response: APIResponse<[BrickLinkColor]>) in
                
                let colors = response.data
                
                return colors
            }
            
            .eraseToAnyPublisher()
    }
    
    
    func getResponse<T>(for request: URLRequest) -> AnyPublisher<T, Never> where T: Decodable {
        
        return Publishers.Future<T, Never> { promise in
        
            URLSession(configuration: .default).dataTask (with: request) { (data, response, error) in
                
                print(String(data: data!, encoding: .utf8)!)
                
                let decoded: T = data!.decode()
                
                promise(.success(decoded))
                
            } .resume()
        }
            
        .eraseToAnyPublisher()
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
