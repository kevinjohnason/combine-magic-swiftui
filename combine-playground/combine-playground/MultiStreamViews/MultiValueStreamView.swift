//
//  CombineStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/7/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct MultiValueStreamView: View {
    @ObservedObject var viewModel: StreamViewModel<[String]>

    var displayActionButtons: Bool = true

    var updateOperationStreamViewModel: UpdateOperationStreamViewModel?

    var updateView: some View {
        guard let updateOperationStreamViewModel = updateOperationStreamViewModel else {
            return AnyView(EmptyView())
        }
        return AnyView(NavigationLink(
             destination: UpdateOperationStreamView(viewModel: updateOperationStreamViewModel),
             label: {
                 HStack {
                     Spacer()
                     Image(systemName: "pencil.circle")
                     .font(.system(size: 25, weight: .light))
                 }.padding(.trailing, 10)
         }))
    }

    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            ZStack {
                Text(viewModel.title)
                    .font(.system(.headline, design: .monospaced))
                    .lineLimit(nil)
                // edit with destination ~~~ kevin start from here
                self.updateView
            }

            Text(viewModel.updatableDescription)
                       .font(.system(.subheadline, design: .monospaced))
                       .lineLimit(nil)

            MultiBallTunnelView(values: $viewModel.values, color: .green,
                                animationSecond: viewModel.animationSeconds).frame(maxHeight: 100)

            if displayActionButtons {
                HStack {
                    CombineDemoButton(text: "Subscribe", backgroundColor: .blue) {
                      self.viewModel.subscribe()
                    }

                    CombineDemoButton(text: "Cancel", backgroundColor: .red) {
                      self.viewModel.cancel()
                    }
                }.padding()
            }
            Spacer()
        }
    }
}

#if DEBUG
struct CombineSingleStreamView_Previews: PreviewProvider {
    static var previews: some View {
        MultiValueStreamView(viewModel: StreamViewModel<[String]>(title: "Stream A",
                                                                  description: "Sequence(A,B,C,D)",
                                                                  publisher: Empty().eraseToAnyPublisher()))
    }
}
#endif
