
import SwiftUI


struct LoadingView : View {
    var body: some View {
        Text("Loading")
    }
}

#if DEBUG
struct LoadingView_Previews : PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
#endif
