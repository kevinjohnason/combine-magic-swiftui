//
//  TransformingOperationStreamListView.swift
//  combine-playground
//
//  Created by kevin.cheng on 2/7/20.
//  Copyright © 2020 Kevin-Cheng. All rights reserved.
//

import SwiftUI

struct TransformingOperationStreamListView: View {
    @EnvironmentObject var streamStore: StreamStore

     func streamView(streamModel: TransformingOperationStreamModel<Int>) -> some View {
         let multiStreamViewModel = MultiStreamViewModel(title: streamModel.name ?? "",
                                                         sourceStreamModel: streamStore.streamAModel,
                                                         operationStreamModel: streamModel)
         return MultiStreamView(viewModel: multiStreamViewModel)
      }

     var body: some View {
        ForEach(streamStore.transformingOperationStreams) { stream in
             NavigationLink(destination: self.streamView(streamModel: stream)) {
                 MenuRow(detailViewName: stream.name ?? "")
             }
         }.onMove { (source, destination) in
             var storedStreams = self.streamStore.operationStreams
             storedStreams.move(fromOffsets: source, toOffset: destination)
             self.streamStore.operationStreams = storedStreams
         }
     }
}

struct TransformingOperationStreamListView_Previews: PreviewProvider {
    static var previews: some View {
        TransformingOperationStreamListView()
    }
}
