//
//  CombineGroupOperationListStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 9/6/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct CombineGroupOperationListStreamView: View {
    @Binding var storedCombineGroupOperationStreams: [CombineGroupOperationStreamModel]
    
    @Binding var storedStreams: [StreamModel<String>]
        
    func streamView(streamModel: CombineGroupOperationStreamModel) -> some View {
        let sourceStreams = storedStreams.filter { $0.isDefault }
        guard sourceStreams.count > 1 else {
            return AnyView(EmptyView())
        }
        
        let operationStreamView =
        MultiStreamView(streamTitle: streamModel.name ?? "",
                        stream1Model: sourceStreams[0],
                        stream2Model: sourceStreams[1], combineStreamModel: streamModel)
                
        return AnyView(operationStreamView)
     }
    
    var body: some View {
        ForEach(storedCombineGroupOperationStreams) { stream in
                NavigationLink(destination: self.streamView(streamModel: stream)) {
                    MenuRow(detailViewName: stream.name ?? "")
            }
        }
    }
}

struct CombineGroupOperationListStreamView_Previews: PreviewProvider {
    static var previews: some View {
        CombineGroupOperationListStreamView(storedCombineGroupOperationStreams: .constant([]), storedStreams: .constant([]))
    }
}
