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
    var disposeBag = DisposeBag()
    var overlay: some View {
        guard let updateOperationViewModel = viewModel.updateOperationStreamViewModel else {
            return AnyView(EmptyView())
        }
        return AnyView(NavigationLink(
            destination: UpdateOperationStreamView(
                viewModel: updateOperationViewModel),
            label: {
                HStack {
                    Spacer()
                    Image(systemName: "pencil.circle")
                    .font(.subheadline)
                    .padding()
                }
        }))
    }

    var body: some View {
        VStack {
            ForEach(viewModel.streamViewModels, id: \.title) { streamView in
                MultiValueStreamView(viewModel: streamView, displayActionButtons: false)
                    .overlay(self.overlay)
                //.navigationBarItems(trailing: trailingBarItem())
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
