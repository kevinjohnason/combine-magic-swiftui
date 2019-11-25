//
//  MultiStreamViewModel.swift
//  combine-playground
//
//  Created by Kevin Cheng on 11/25/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import Foundation
import Combine

class MultiStreamViewModel: ObservableObject {
    @Published var sourceStreamModel: StreamModel<String>?
    @Published var operationStreamModel: OperationStreamModel?
    @Published var streamViewModels: [StreamViewModel<[String]>]
    var title: String

    init(title: String, sourceStreamModel: StreamModel<String>, operationStreamModel: OperationStreamModel) {
        self.title = title
        self.sourceStreamModel = sourceStreamModel
        self.operationStreamModel = operationStreamModel
        let sourceViewModel = StreamViewModel(title: sourceStreamModel.name ?? "",
                                              description: sourceStreamModel.sequenceDescription,
                                              publisher: sourceStreamModel.toPublisher()).toArrayViewModel()
        var streamViewModels: [StreamViewModel<[String]>] = [sourceViewModel]
        var currentOperatorItem: Operator?  = operationStreamModel.operatorItem
        var currentPublisher: AnyPublisher<String, Never>? = sourceStreamModel.toPublisher()
        while currentOperatorItem != nil {
            let newPublisher = currentOperatorItem!.applyPublisher(currentPublisher!)
            streamViewModels.append(StreamViewModel(title: currentOperatorItem!.description,
                                                    description: "",
                                                    publisher: newPublisher).toArrayViewModel())
            currentOperatorItem = currentOperatorItem?.next
            currentPublisher = newPublisher
        }
        self.streamViewModels = streamViewModels
    }
    init(streamTitle: String, stream1Model: StreamModel<String>, stream2Model: StreamModel<String>,
         unifyingStreamModel: UnifyingOperationStreamModel) {
        self.title = streamTitle
        let stream1ViewModel = StreamViewModel(title: stream1Model.name ?? "",
                                               description: stream1Model.sequenceDescription,
            publisher: stream1Model.toPublisher()).toArrayViewModel()

        let stream2ViewModel = StreamViewModel(title: stream2Model.name ?? "",
                                               description: stream2Model.sequenceDescription,
            publisher: stream2Model.toPublisher()).toArrayViewModel()

        let operatorPublisher =
            unifyingStreamModel.operatorItem.applyPublishers([stream1Model.toPublisher(),
                                                              stream2Model.toPublisher()])

        let resultViewModel = StreamViewModel(title: unifyingStreamModel.name ?? "",
                                              description: unifyingStreamModel.description ?? "",
            publisher: operatorPublisher).toArrayViewModel()
        streamViewModels = [stream1ViewModel, stream2ViewModel, resultViewModel]
    }

    init(streamTitle: String, stream1Model: StreamModel<String>,
         stream2Model: StreamModel<String>, joinStreamModel: JoinOperationStreamModel) {
        title = streamTitle
        let stream1ViewModel: StreamViewModel<String> = DataStreamViewModel(streamModel: stream1Model)
        let stream2ViewModel: StreamViewModel<String> = DataStreamViewModel(streamModel: stream2Model)
        let operatorPublisher =
            joinStreamModel.operatorItem.applyPublishers([stream1Model.toPublisher(), stream2Model.toPublisher()])
        let resultStreamViewModel =
            StreamViewModel(title: joinStreamModel.name ?? "",
                            description: joinStreamModel.description ?? "", publisher: operatorPublisher)
        streamViewModels = [stream1ViewModel.toArrayViewModel(),
                            stream2ViewModel.toArrayViewModel(),
                            resultStreamViewModel]
    }
}
