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

    func trailingBarItem() -> some View {
        let navigationLink = NavigationLink(
        destination: UpdateOperationStreamView(
            viewModel: UpdateOperationStreamViewModel(sourceStreamModel: streamStore.streamAModel))) {
            Text("Add")
        }
        return AnyView(navigationLink)
    }
    
    func overlay(with streamViewModel: StreamViewModel<[String]>) -> some View {
        guard streamViewModel.editable else {
            return AnyView(EmptyView())
        }
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
                    .overlay(self.overlay(with: streamView))
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
