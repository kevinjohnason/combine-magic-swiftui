//
//  BallTunnelView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/2/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct BoundsPreferenceData {
    let bounds: Anchor<CGRect>?
}

struct TunnelPreferenceKey: PreferenceKey {
    static var defaultValue: BoundsPreferenceData = BoundsPreferenceData(bounds: nil)
    
    static func reduce(value: inout BoundsPreferenceData, nextValue: () -> BoundsPreferenceData) {
        value = nextValue()
    }
    typealias Value = BoundsPreferenceData
}

struct BallTunnelView: View {    
    @Binding var values: [TimeSeriesValue<String>]
    var color: Color = .green
    
    var animationSecond: Double = 2
    
    var ballRadius: CGFloat = 48
    
    var padding: CGFloat = 5
    
    let tunnelColor: Color = Color(red: 242/255.0, green: 242/255.0, blue: 242/255.0)

    var body: some View {
        GeometryReader { tunnelGeometry in
            HStack(spacing: 0) {
                ForEach(self.values.reversed()) { value in
                    CircularTextView(forgroundColor: .white, backgroundColor: self.color, viewModel: CircularTextViewModel(value: value.value))
                        .frame(width: self.ballRadius, height: self.ballRadius, alignment: .center)
                        .transition(.asymmetric(insertion: .offset(x: -tunnelGeometry.size.width, y: 0),
                                                removal: .offset(x: tunnelGeometry.size.width, y: 0)))
                }
            }
            .frame(minWidth: self.tunnelWidth(with: tunnelGeometry.size.width),
                   minHeight: self.ballRadius, alignment: .trailing).offset(x: self.tunnelOffset(with: tunnelGeometry.size.width))
            .padding([.top, .bottom], self.padding)            
                .background(self.tunnelColor)
            .anchorPreference(key: TunnelPreferenceKey.self, value: .bounds, transform: {
                BoundsPreferenceData(bounds: $0)
            }).animation(.easeInOut(duration: self.animationSecond))
        }
    }
    
    func tunnelWidth(with screenWidth: CGFloat) -> CGFloat {
        max(screenWidth, self.ballRadius * CGFloat(self.values.count))
    }
    
    func tunnelOffset(with screenWidth: CGFloat) -> CGFloat {
        (tunnelWidth(with: screenWidth) - screenWidth) / 2
    }
}

#if DEBUG
struct BallTunnelView_Previews: PreviewProvider {
    static var previews: some View {
        BallTunnelView(values: .constant([]))
    }
}
#endif
