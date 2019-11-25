//
//  MultiStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 9/12/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine

struct MultiStreamView: View {
    @ObservedObject var viewModel: MultiStreamViewModel

    var body: some View {
        VStack {
            ForEach(viewModel.streamViewModels, id: \.title) { streamView in
                MultiValueStreamView(viewModel: streamView, displayActionButtons: false)
            }
            HStack {
                CombineDemoButton(text: "Subscribe", backgroundColor: .blue) {
                    self.viewModel.streamViewModels.forEach {
                        $0.subscribe()
                    }
                }
                CombineDemoButton(text: "Cancel", backgroundColor: .red) {
                    self.viewModel.streamViewModels.forEach {
                        $0.cancel()
                    }
                }
            }.padding()
        }.navigationBarTitle(viewModel.title)
    }
}

//struct MultiStreamView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultiStreamView(streamTitle: "",
//                        sourceStreamModel: StreamModel<String>.new(),
//                        operationStreamModel: .delay(seconds: 1, next: nil))
//    }
//}
