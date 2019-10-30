//
//  StreamView.swift
//  CombineTutorial
//
//  Created by kevin.cheng on 9/25/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct StreamView: View {
    
    @State var streamValues: [[String]] = []
    
    @State private var nextValue = 0
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            TunnelView(streamValues: $streamValues)
            HStack {
                Button("Add") {
                    self.nextValue += 1
                    self.streamValues.append([String(self.nextValue)])
                }
                Button("Remove") {
                    self.streamValues.remove(at: 0)
                }
            }
            Spacer()
        }
    }
}

struct StreamView_Previews: PreviewProvider {
    static var previews: some View {
        StreamView(streamValues: [["1", "B"]])
    }
}
