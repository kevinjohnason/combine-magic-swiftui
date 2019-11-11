import SwiftUI
struct CircularTextArrayView: View {
    
    var texts: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(self.texts, id: \.self) { value in
                CircularTextView(text: value)
            }
        }
    }
}

struct MultiCircularTextView_Previews: PreviewProvider {
    static var previews: some View {
        CircularTextArrayView(texts: ["1", "2"]).previewLayout(.sizeThatFits)
    }
}
