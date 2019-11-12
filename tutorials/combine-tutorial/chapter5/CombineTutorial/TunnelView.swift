import SwiftUI
struct TunnelView: View {
    
    @Binding var streamValues: [[String]]
    
    let verticalPadding: CGFloat = 5
    
    let tunnelColor: Color = Color(red: 242/255.0, green: 242/255.0, blue: 242/255.0)
    
    var body: some View {
        GeometryReader { reader in
            HStack(spacing: self.verticalPadding) {
                ForEach(self.streamValues.reversed(), id: \.self) { texts in
                    CircularTextArrayView(texts: texts)
                        .transition(.asymmetric(insertion: .offset(x: -reader.size.width, y: 0),
                                                removal: .offset(x: reader.size.width, y: 0)))
                }
            }
            .frame(width: reader.size.width, alignment: .trailing)
        }.animation(.easeInOut(duration: 2))
            .padding([.top, .bottom], self.verticalPadding)
            .frame(minHeight: 60)
            .background(self.tunnelColor)
        
    }
}

struct TunnelView_Previews: PreviewProvider {
    static var previews: some View {
        Section {
            TunnelView(streamValues: .constant([["1"], ["2"], ["3"]]))
            TunnelView(streamValues: .constant([["A"], ["B"], ["C"]]))
            TunnelView(streamValues: .constant([["1", "A"], ["2", "B"], ["3", "C"]]))
        }.previewLayout(.sizeThatFits)
    }
}
