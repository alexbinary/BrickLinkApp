
import Foundation
import SwiftUI



struct BrickLinkColor: Decodable, Identifiable {
    
    var id: Int { colorId }
    
    let colorId: Int
    let colorName: String
    let colorCode: String
    let colorType: String
}
