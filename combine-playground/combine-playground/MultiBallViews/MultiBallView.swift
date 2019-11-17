//
//  MultiBallView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 9/12/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct MultiBallView: View {
    var forgroundColor: Color
    var backgroundColor: Color
    @Binding var viewModel: MultiBallViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.values, id: \.self) { value in
                CircularTextView(forgroundColor: self.forgroundColor,
                         backgroundColor: self.backgroundColor, viewModel: CircularTextViewModel(value: value))
            }
        }
    }
}

struct MultiBallView_Previews: PreviewProvider {
    static var previews: some View {
        MultiBallView(forgroundColor: .red, backgroundColor: .red, viewModel: .constant(MultiBallViewModel(values: [])))
    }
}
