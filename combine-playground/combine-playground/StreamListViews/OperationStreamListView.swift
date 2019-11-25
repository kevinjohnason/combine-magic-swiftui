//
//  OperationStreamListView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 9/6/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct OperationStreamListView: View {
    @EnvironmentObject var streamStore: StreamStore

    func streamView(streamModel: OperationStreamModel) -> some View {
        let multiStreamViewModel = MultiStreamViewModel(title: streamModel.name ?? "",
                                                        sourceStreamModel: streamStore.streamAModel,
                                                        operationStreamModel: streamModel)
        return MultiStreamView(viewModel: multiStreamViewModel)
            .overlay(NavigationLink(
                destination: UpdateOperationStreamView(
                    viewModel: UpdateOperationStreamViewModel(streamStore: streamStore,
                                                              operationStreamModel: streamModel)),
                label: {
                    HStack {
                        Spacer()
                        Image(systemName: "pencil.circle")
                        .font(.subheadline)
                        .padding()
                    }
            }))
            .navigationBarItems(trailing: trailingBarItem())
     }

    var body: some View {
        ForEach(streamStore.operationStreams) { stream in
            NavigationLink(destination: self.streamView(streamModel: stream)) {
                MenuRow(detailViewName: stream.name ?? "")
            }
        }
    }

    func trailingBarItem() -> some View {
        let navigationLink = NavigationLink(
        destination: UpdateOperationStreamView(
            viewModel: UpdateOperationStreamViewModel(streamStore: streamStore))) {
            Text("Add")
        }
        return AnyView(navigationLink)
    }
}

struct OperationStreamListView_Previews: PreviewProvider {
    static var previews: some View {
        OperationStreamListView()
    }
}
