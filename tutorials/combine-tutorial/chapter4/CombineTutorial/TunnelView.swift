import SwiftUI
struct TunnelView: View {
    
    @Binding var streamValues: [[String]]
    
    let verticalPadding: CGFloat = 5
     
    let tunnelColor: Color = Color(red: 242/255.0, green: 242/255.0, blue: 242/255.0)
    
    var body: some View {
        HStack(spacing: verticalPadding) {
            ForEach(streamValues.reversed(), id: \.self) { texts in
                CircularTextArrayView(texts: texts)
            }
        }.padding(.horizontal, 5).padding(.vertical, 5)
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .trailing)
        .padding([.top, .bottom], verticalPadding)
        .background(tunnelColor)
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
