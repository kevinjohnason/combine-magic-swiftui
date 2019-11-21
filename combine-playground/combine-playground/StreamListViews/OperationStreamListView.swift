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
        return AnyView(MultiStreamView(streamTitle: streamModel.name ?? "",
                                       sourceStreamModel: sourceStream,
                                       operatorItem: streamModel.operatorItem)
            .navigationBarItems(trailing: trailingBarItem(sourceStream: sourceStream,
                                                          operationStreamModel: streamModel)))
     }

    var body: some View {
        ForEach(storedOperationStreams) { stream in
            NavigationLink(destination: self.streamView(streamModel: stream)) {
                MenuRow(detailViewName: stream.name ?? "")
            }
        }
    }

    func trailingBarItem(sourceStream: StreamModel<String>, operationStreamModel: OperationStreamModel) -> some View {
        let navigationLink = NavigationLink(
        destination: UpdateOperationStreamView(
            viewModel: UpdateOperationStreamViewModel(streamModel: sourceStream,
                                                      operationStreamModel: operationStreamModel))) {
            Text("Edit")
        }
        return AnyView(navigationLink)
    }
}

struct OperationStreamListView_Previews: PreviewProvider {
    static var previews: some View {
        OperationStreamListView(storedOperationStreams: .constant([]))
    }
}
