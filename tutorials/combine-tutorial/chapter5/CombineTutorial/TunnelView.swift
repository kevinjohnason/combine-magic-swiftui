//
//  TunnelView.swift
//  CombineTutorial
//
//  Created by kevin.cheng on 9/24/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
struct TunnelView: View {
    
    @Binding var streamValues: [[String]]
    
    let spacing: CGFloat = 5
    
    let tunnelColor: Color = Color(red: 242/255.0, green: 242/255.0, blue: 242/255.0)
            
    let radius: CGFloat = 50
    
    var body: some View {
        GeometryReader { reader in
            HStack(spacing: self.spacing) {
                ForEach(self.streamValues.reversed(), id: \.self) { texts in
                    CircularTextArrayView(texts: texts)
                        .transition(.asymmetric(insertion: .offset(x: -reader.size.width, y: 0),
                                                removal: .offset(x: reader.size.width, y: 0)))
                }
            }
            .frame(width: self.tunnelWidth(with: reader.size.width), alignment: .trailing)
            .offset(x: self.tunnelOffset(with: reader.size.width))
            
        }.animation(.easeInOut(duration: 1))
        .padding([.top, .bottom], self.spacing)
        .frame(height: 60)
        .background(self.tunnelColor)
    }
    
    func tunnelWidth(with containerWidth: CGFloat) -> CGFloat {
        max(containerWidth, (radius * 2 + spacing) * CGFloat(streamValues.count))
    }
    
    func tunnelOffset(with containerWidth: CGFloat) -> CGFloat {
        (tunnelWidth(with: containerWidth) - containerWidth) / 2
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
