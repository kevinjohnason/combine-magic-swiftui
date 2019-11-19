import SwiftUI
struct CircularTextView: View {
    
    @State var text: String        
    
    var body: some View {
        Text(text)
        .font(.system(size: 14))
        .bold()
        .foregroundColor(Color.white)
        .padding()
        .frame(minWidth: 50, minHeight: 50)
        .background(Color.green)
        .clipShape(Circle())
        .shadow(radius: 1)        
    }
}

struct CircularTextView_Previews: PreviewProvider {
    static var previews: some View {
        Section {
            CircularTextView(text: "A")
        }.previewLayout(.sizeThatFits)
    }
}
