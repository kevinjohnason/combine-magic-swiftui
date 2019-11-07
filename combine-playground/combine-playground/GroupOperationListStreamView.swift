//
//  GroupOperationListStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 9/6/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct GroupOperationListStreamView: View {
    
    @Binding var storedGroupOperationStreams: [GroupOperationStreamModel]
    
    @Binding var storedStreams: [StreamModel<String>]
        
    func streamView(streamModel: GroupOperationStreamModel) -> some View {
        let sourceStreams = storedStreams.filter { $0.isDefault }
        guard sourceStreams.count > 1 else {
            return AnyView(EmptyView())
        }
        let operationStreamView = MultiStreamView(streamTitle: streamModel.name ?? "",
                                                  stream1Model: sourceStreams[0],
                                                  stream2Model: sourceStreams[1], groupStreamModel: streamModel)        
        return AnyView(operationStreamView)
     }
    
    var body: some View {
        ForEach(storedGroupOperationStreams) { stream in
                NavigationLink(destination: self.streamView(streamModel: stream)) {
                    MenuRow(detailViewName: stream.name ?? "")
            }
        }
    }
}

struct GroupOperationListStreamView_Previews: PreviewProvider {
    static var previews: some View {
        GroupOperationListStreamView(storedGroupOperationStreams: .constant([]), storedStreams: .constant([]))
    }
}
