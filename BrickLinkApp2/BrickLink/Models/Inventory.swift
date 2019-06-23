
import Foundation
import SwiftUI



struct Inventory: Codable, Identifiable {
    
    var id: Int { inventoryId }
    
    let inventoryId: Int
    let item: InventoryItem
    let colorId: Int
    let colorName: String
    let quantity: Int
    var unitPrice: FixedPointNumber
    let newOrUsed: ItemCondition
    let isRetain: Bool
    let isStockRoom: Bool
    let description: String
    let saleRate: Int
    
    func matches(query: String) -> Bool {
        
        return
            item.name.lowercased().contains(query.lowercased())
            ||
            item.no.lowercased().contains(query.lowercased())
    }
}


struct InventoryItem: Codable {
    
    let type: ItemType
    let no: String
    let name: String
}


enum ItemType: String, Codable {
    
    case part = "PART"
}


enum ItemCondition: String, Codable {
    
    case new = "N"
    case used = "U"
    
    var description: String {
        switch self {
        case .new:
            return "new"
        case .used:
            return "used"
        }
    }
}


struct FixedPointNumber: Codable, ExpressibleByFloatLiteral {
    
    typealias FloatLiteralType = Float
    
    init(floatLiteral value: FloatLiteralType) {
        self.floatValue = value
    }
    
    init(_ float: Float) {
        self.floatValue = float
    }
    
    var floatValue: Float
    
    init(from decoder: Decoder) throws {
        
        let stringValue = try! decoder.singleValueContainer().decode(String.self)
        self.floatValue = Float(stringValue)!
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try! container.encode(self.floatValue)
    }
}
