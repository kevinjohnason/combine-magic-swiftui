//
//  MultiCircularTextView.swift
//  CombineTutorial
//
//  Created by Kevin Cheng on 10/30/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
struct MultiCircularTextView: View {
    
    var texts: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(texts, id: \.self) { value in
                CircularTextView(text: value)
            }
        }
    }
}

struct MultiCircularTextView_Previews: PreviewProvider {
    static var previews: some View {
        MultiCircularTextView(texts: ["1", "2"])
    }
}
