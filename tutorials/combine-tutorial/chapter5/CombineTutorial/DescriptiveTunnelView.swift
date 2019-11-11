//
//  DescriptiveTunnelView.swift
//  CombineTutorial
//
//  Created by Kevin Cheng on 11/8/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI

struct DescriptiveTunnelView: View {
    
    @Binding var streamValues: [[String]]
    
    var description: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text(description).font(.system(.subheadline, design: .monospaced))
            TunnelView(streamValues: $streamValues)
        }
    }
}

struct DescriptiveTunnelView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptiveTunnelView(streamValues: .constant([]), description: "")
    }
}
