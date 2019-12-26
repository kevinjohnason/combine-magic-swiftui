//
//  CombineGroupOperationListStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 9/6/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct JoinOperationListStreamView: View {

    @EnvironmentObject var streamStore: StreamStore

    func streamView(streamModel: JoinOperationStreamModel) -> some View {
        let sourceStreams = streamStore.streams.filter { $0.isDefault }
        guard sourceStreams.count > 1 else {
            return AnyView(EmptyView())
        }
        let viewModel = MultiStreamViewModel(streamTitle: streamModel.name ?? "",
                                            stream1Model: sourceStreams[0],
                                            stream2Model: sourceStreams[1],
                                            joinStreamModel: streamModel)
        let operationStreamView = MultiStreamView(viewModel: viewModel)
        return AnyView(operationStreamView)
     }

    var body: some View {
        ForEach(streamStore.joinStreams) { stream in
                NavigationLink(destination: self.streamView(streamModel: stream)) {
                    MenuRow(detailViewName: stream.name ?? "")
            }
        }.onMove { (source, destination) in
            var storedStreams = self.streamStore.joinStreams
            storedStreams.move(fromOffsets: source, toOffset: destination)
            self.streamStore.joinStreams = storedStreams
        }
    }
}

struct JoinOperationListStreamView_Previews: PreviewProvider {
    static var previews: some View {
        JoinOperationListStreamView()
    }
}
