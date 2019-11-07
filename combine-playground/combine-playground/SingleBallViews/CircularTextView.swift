//
//  BallView.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct CircularTextView: View {
    var forgroundColor: Color
    var backgroundColor: Color
    var draggable: Bool = false
    @ObservedObject var viewModel: CircularTextViewModel    
    
    var body: some View {
        Text(self.viewModel.value)
            .font(.system(size: 14))
            .bold()
            .foregroundColor(self.forgroundColor)
            .padding()
            .background(self.backgroundColor)
            .clipShape(Circle())
            .shadow(radius: 1)
            .offset(self.viewModel.offset)
            .opacity(viewModel.isHidden ? 0 : 1)
    }
}

#if DEBUG
struct BallView_Previews: PreviewProvider {
    static var previews: some View {
        CircularTextView(forgroundColor: .white, backgroundColor: .red,
                 viewModel: CircularTextViewModel(value: ""))
    }
}
#endif
