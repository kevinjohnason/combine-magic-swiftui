//
//  CircularTextView.swift
//  CombineTutorial
//
//  Created by kevin.cheng on 9/24/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI

struct CircularTextView: View {
    
    @State var text: String        
    

    var radius: CGFloat = 50


    var body: some View {
        Text(text)
        .font(.system(size: 14))
        .bold()
        .foregroundColor(Color.white)
        .padding()
        .frame(width: radius, height: radius)
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
