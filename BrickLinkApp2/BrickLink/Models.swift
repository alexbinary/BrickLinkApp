
import Foundation
import SwiftUI



struct APIResponse<T>: Decodable where T: Decodable {
    
    let data: T
}


struct Order: Decodable, Identifiable {
    
    var id: String { orderId.stringValue }
    
    let orderId: OrderId
    let dateOrdered: Date
    let dateStatusChanged: Date
    let buyerName: String
    let buyerEmail: String?
    let status: OrderStatus
    let totalCount: Int
    let uniqueCount: Int
}

struct OrderId: Decodable, CustomStringConvertible {
    
    let stringValue: String
    
    init(from decoder: Decoder) throws {
        
        let intValue = try! decoder.singleValueContainer().decode(Int.self)
        self.stringValue = "\(intValue)"
    }
    
    var description: String { stringValue }
}

enum OrderStatus: String, Decodable, CaseIterable {
    
    case completed = "COMPLETED"
    case shipped = "SHIPPED"
    case received = "RECEIVED"
}
