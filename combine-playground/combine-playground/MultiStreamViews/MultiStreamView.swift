//
//  MultiStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 9/12/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine

struct MultiStreamView: View {
    let streamViewModels: [StreamViewModel<[String]>]
    let streamTitle: String
            
    init(streamTitle: String, sourceStreamModel: StreamModel<String>, operatorItem: Operator) {
        self.streamTitle = streamTitle
                        
        let sourceViewModel = StreamViewModel(title: sourceStreamModel.name ?? "",
                                              description: sourceStreamModel.sequenceDescription,
                                              publisher: sourceStreamModel.toPublisher()).toArrayViewModel()
        
        var streamViewModels: [StreamViewModel<[String]>] = [sourceViewModel]
        
        var currentOperatorItem: Operator?  = operatorItem
        var currentPublisher: AnyPublisher<String, Never>? = sourceStreamModel.toPublisher()
        while currentOperatorItem != nil {
            let newPublisher = currentOperatorItem!.applyPublisher(currentPublisher!)
            streamViewModels.append(StreamViewModel(title:
                currentOperatorItem!.description, description: currentOperatorItem!.description, publisher: newPublisher).toArrayViewModel())
            currentOperatorItem = currentOperatorItem?.next
            currentPublisher = newPublisher
        }

        self.streamViewModels = streamViewModels
    }
        
    init(streamTitle: String, stream1Model: StreamModel<String>, stream2Model: StreamModel<String>,
         groupStreamModel: GroupOperationStreamModel) {
        self.streamTitle = streamTitle
        let stream1ViewModel = StreamViewModel(title: stream1Model.name ?? "",
                                               description: stream1Model.sequenceDescription,
            publisher: stream1Model.toPublisher()).toArrayViewModel()
            
        let stream2ViewModel = StreamViewModel(title: stream2Model.name ?? "",
                                               description: stream2Model.sequenceDescription,
            publisher: stream2Model.toPublisher()).toArrayViewModel()
            
        let operatorPublisher = groupStreamModel.operationType.applyPublishers([stream1Model.toPublisher(), stream2Model.toPublisher()])
        
        let resultViewModel = StreamViewModel(title: groupStreamModel.name ?? "",
                                              description: groupStreamModel.description ?? "",
            publisher: operatorPublisher).toArrayViewModel()
        streamViewModels = [stream1ViewModel, stream2ViewModel, resultViewModel]
                    
    }
    
    init(streamTitle: String, stream1Model: StreamModel<String>,
         stream2Model: StreamModel<String>, combineStreamModel: CombineGroupOperationStreamModel) {
        self.streamTitle = streamTitle
        let stream1ViewModel: StreamViewModel<String> = DataStreamViewModel(streamModel: stream1Model)
        let stream2ViewModel: StreamViewModel<String> = DataStreamViewModel(streamModel: stream2Model)
        let operatorPublisher = combineStreamModel.operatorType.applyPublishers([stream1Model.toPublisher(), stream2Model.toPublisher()])
        let resultStreamViewModel = StreamViewModel(title: combineStreamModel.description ?? "",
                                                description: combineStreamModel.description ?? "", publisher: operatorPublisher)
        
        streamViewModels = [stream1ViewModel.toArrayViewModel(),
                            stream2ViewModel.toArrayViewModel(),
                            resultStreamViewModel]
        
    }
    
    var body: some View {
        VStack {
            ForEach(streamViewModels, id: \.title) { streamView in
                MultiValueStreamView(viewModel: streamView, displayActionButtons: false)
            }
            HStack {
                CombineDemoButton(text: "Subscribe", backgroundColor: .blue) {
                    self.streamViewModels.forEach {
                        $0.subscribe()
                    }
                }
                CombineDemoButton(text: "Cancel", backgroundColor: .red) {
                    self.streamViewModels.forEach {
                        $0.cancel()
                    }
                }
            }.padding()
        }.navigationBarTitle(streamTitle)
    }
}

struct MultiStreamView_Previews: PreviewProvider {
    static var previews: some View {
        MultiStreamView(streamTitle: "",
                        sourceStreamModel: StreamModel<String>.new(),
                        operatorItem: .delay(seconds: 1, next: nil))
    }
}
