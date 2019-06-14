
import Foundation
import SwiftUI



struct APIResponse<T>: Decodable where T: Decodable {
    
    let data: T
}


struct Order: Decodable, Identifiable {
    
    var id: String { "\(orderId)" }
    
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
