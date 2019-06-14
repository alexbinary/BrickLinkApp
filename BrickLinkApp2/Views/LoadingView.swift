
import SwiftUI


struct LoadingView : View {
    
    let text: String
    
    var body: some View {
        Text(text)
    }
}

#if DEBUG
struct LoadingView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            
            LoadingView(text: "Loading")
            LoadingView(text: "Loading orders")
            LoadingView(text: "Loading please wait")
            
        } .previewLayout(.fixed(width: 300, height: 100))
    }
}
#endif
