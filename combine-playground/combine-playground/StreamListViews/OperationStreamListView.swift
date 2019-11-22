//
//  OperationStreamListView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 9/6/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct OperationStreamListView: View {
    @Binding var storedOperationStreams: [OperationStreamModel]
    @EnvironmentObject var streamStore: StreamStore

    func streamView(streamModel: OperationStreamModel) -> some View {
        return MultiStreamView(streamTitle: streamModel.name ?? "",
                               sourceStreamModel: streamStore.streamAModel,
                               operatorItem: streamModel.operatorItem)
            .overlay(NavigationLink(
                destination: UpdateOperationStreamView(
                    viewModel: UpdateOperationStreamViewModel(streamStore: streamStore,
                                                              operationStreamModel: streamModel)),
                label: {
                    HStack {
                        Spacer()
                        Text("Edit").font(.subheadline)
                        .padding()
                    }
            }))
            .navigationBarItems(trailing: trailingBarItem())
     }

    var body: some View {
        ForEach(storedOperationStreams) { stream in
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
        OperationStreamListView(storedOperationStreams: .constant([]))
    }
}
