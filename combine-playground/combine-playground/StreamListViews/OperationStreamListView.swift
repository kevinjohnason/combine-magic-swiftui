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
    
    @Binding var storedStreams: [StreamModel<String>]
    
    func sourceStream(with id: UUID) -> StreamModel<String>? {
        storedStreams.first(where: { $0.id == id })
    }
        
    func streamView(streamModel: OperationStreamModel) -> some View {
        guard let sourceStream = sourceStream(with: streamModel.streamModelId) else {
            return AnyView(EmptyView())
        }
        return AnyView(MultiStreamView(streamTitle: streamModel.name ?? "",
                                       sourceStreamModel: sourceStream,
                                       operatorItem: streamModel.operatorItem))
     }
    
    var body: some View {
        ForEach(storedOperationStreams) { stream in
            NavigationLink(destination: self.streamView(streamModel: stream)) {
                MenuRow(detailViewName: stream.name ?? "")
            }
        }
    }
}

struct OperationStreamListView_Previews: PreviewProvider {
    static var previews: some View {
        OperationStreamListView(storedOperationStreams: .constant([]),
                                storedStreams: .constant([]))
    }
}
