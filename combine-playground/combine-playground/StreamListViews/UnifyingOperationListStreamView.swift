//
//  GroupOperationListStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 9/6/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct UnifyingOperationListStreamView: View {
    
    @Binding var storedUnifyingOperationStreams: [UnifyingOperationStreamModel]
    
    @EnvironmentObject var streamStore: StreamStore
        
    func streamView(streamModel: UnifyingOperationStreamModel) -> some View {
        let sourceStreams = streamStore.streams.filter { $0.isDefault }
        guard sourceStreams.count > 1 else {
            return AnyView(EmptyView())
        }
        let operationStreamView = MultiStreamView(streamTitle: streamModel.name ?? "",
                                                  stream1Model: sourceStreams[0],
                                                  stream2Model: sourceStreams[1], unifyingStreamModel: streamModel)        
        return AnyView(operationStreamView)
     }
    
    var body: some View {
        ForEach(storedUnifyingOperationStreams) { stream in
                NavigationLink(destination: self.streamView(streamModel: stream)) {
                    MenuRow(detailViewName: stream.name ?? "")
            }
        }
    }
}

struct GroupOperationListStreamView_Previews: PreviewProvider {
    static var previews: some View {
        UnifyingOperationListStreamView(storedUnifyingOperationStreams: .constant([]))
    }
}
