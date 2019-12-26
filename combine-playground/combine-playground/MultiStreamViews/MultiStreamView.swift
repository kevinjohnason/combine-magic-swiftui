//
//  MultiStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 9/12/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine
import CombineExtensions
struct MultiStreamView: View {
    @ObservedObject var viewModel: MultiStreamViewModel
    @EnvironmentObject var streamStore: StreamStore

    func trailingBarItem() -> some View {
        guard viewModel.operationStreamModel != nil,
            let operationStreamViewModel = viewModel.addOperationStreamViewModel else {
            return AnyView(EmptyView())
        }
        let navigationLink = NavigationLink(
        destination: UpdateOperationStreamView(
            viewModel: operationStreamViewModel)) {
            Image(systemName: "plus.circle").font(Font.system(size: 30))
        }
        return AnyView(navigationLink)
    }

    var body: some View {
        VStack {
            ForEach(viewModel.streamViewModels, id: \.title) { streamViewModel in
                MultiValueStreamView(viewModel: streamViewModel,
                                     displayActionButtons: false)
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
        .navigationBarItems(trailing: self.trailingBarItem())
    }
}

//struct MultiStreamView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultiStreamView(streamTitle: "",
//                        sourceStreamModel: StreamModel<String>.new(),
//                        operationStreamModel: .delay(seconds: 1, next: nil))
//    }
//}
