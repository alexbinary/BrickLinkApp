
import Foundation



struct Inventory: Codable {
    
    let item: InventoryItem
    let colorId: ColorId
    let quantity: Int
    var unitPrice: FixedPointNumber
    let newOrUsed: ItemCondition
    let isRetain: Bool
    let isStockRoom: Bool
    let description: String
}


struct InventoryItem: Codable {
    
    let type: ItemType
    let no: String
}


enum ItemType: String, Codable {
    
    case part = "PART"
}


enum ColorId: Int, Codable {
    
    case blue = 7
    case red = 5
    
    var name: String {
        
        switch self {
            
        case .blue:
            return "blue"
        case .red:
            return "red"
        }
    }
}


enum ItemCondition: String, Codable {
    
    case new = "N"
    case used = "U"
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
