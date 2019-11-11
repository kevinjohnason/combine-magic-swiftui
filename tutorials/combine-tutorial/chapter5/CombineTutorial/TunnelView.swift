import SwiftUI
struct TunnelView: View {
    
    @Binding var streamValues: [[String]]
    
    let verticalPadding: CGFloat = 5
    
    let tunnelColor: Color = Color(red: 242/255.0, green: 242/255.0, blue: 242/255.0)
    
    var body: some View {        
        HStack(spacing: self.verticalPadding) {
            ForEach(self.streamValues.reversed(), id: \.self) { texts in
                CircularTextArrayView(texts: texts)
            }
        }
        .animation(.easeInOut)
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .trailing)
        .padding([.top, .bottom], self.verticalPadding)
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
