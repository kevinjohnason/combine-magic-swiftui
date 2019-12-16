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
        let navigationLink = NavigationLink(
        destination: UpdateOperationStreamView(
            viewModel: UpdateOperationStreamViewModel(sourceStreamModel: streamStore.streamAModel))) {
            Text("Add")
        }
        return AnyView(navigationLink)
    }

    func updateOperationStreamView(with streamViewModel: StreamViewModel<[String]>) -> AnyView? {
        guard streamViewModel.editable else {
            return nil
        }

        if let updateOperationViewModel = viewModel.updateOperationStreamViewModel {
            return AnyView(UpdateOperationStreamView(viewModel: updateOperationViewModel))
        }

        if let updateUnifyingViewModel = viewModel.updateUnifyingStreamViewModel {
            return AnyView(UpdateUnifyingStreamView(viewModel: updateUnifyingViewModel))
        }

        return nil
    }

    var body: some View {
        VStack {
            ForEach(viewModel.streamViewModels, id: \.title) { streamView in
                MultiValueStreamView(viewModel: streamView, displayActionButtons: false,
                                     updateOperationStreamView:
                    self.updateOperationStreamView(with: streamView))
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
