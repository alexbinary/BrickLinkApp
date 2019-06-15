
import Foundation



struct APIResponse<T>: Decodable where T: Decodable {
    
    let data: T
}
