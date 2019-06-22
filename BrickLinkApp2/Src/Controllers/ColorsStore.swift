
import Foundation
import SwiftUI
import Combine



class ColorsStore: BindableObject {

    
    let didChange = PassthroughSubject<Void, Never>()
    
    
    var colors: [BrickLinkColor] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(())
            }
        }
    }
}
