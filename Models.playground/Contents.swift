
import UIKit



func getOrder() -> Order {
    
    
    let url = Bundle.main.url(forResource: "orders", withExtension: "json")!
    
    let data = try! Data(contentsOf: url)
    
    let decoder = JSONDecoder()
    
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
    
    decoder.dateDecodingStrategy = .custom({ (decoder) in
        let stringValue = try! decoder.singleValueContainer().decode(String.self)
        return dateFormatter.date(from: stringValue)!
    })
    
    let response = try! decoder.decode(APIResponse<[Order]>.self, from: data)
    
    let orders = response.data
    
    let firstOrder = orders[2]
    
    return firstOrder
}




struct APIResponse<T>: Decodable where T: Decodable {
    
    let data: T
}


struct Order: Decodable {
    
    let orderId: Int
    let dateOrdered: Date
    let dateStatusChanged: Date
    let buyerName: String
    let buyerEmail: String?
    let status: OrderStatus
    let totalCount: Int
    let uniqueCount: Int
}


enum OrderStatus: String, Decodable {
    
    case completed = "COMPLETED"
    case shipped = "SHIPPED"
    case received = "RECEIVED"
}


let order = getOrder()




