//
//  MultiStreamViewModel.swift
//  combine-playground
//
//  Created by Kevin Cheng on 11/25/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import Foundation
import Combine
import CombineExtensions
class MultiStreamViewModel: ObservableObject {
    @Published var streamViewModels: [StreamViewModel<[String]>] = []
    var sourceStreamModel: StreamModel<String>?
    @Published var operationStreamModel: OperationStreamModel?
    var title: String
    var disposeBag = DisposeBag()
    var updateOperationStreamViewModel: UpdateOperationStreamViewModel? {
        guard let sourceStreamModel = sourceStreamModel, let operationStreamModel = operationStreamModel else {
            return nil
        }
        let updateStreamViewModel = UpdateOperationStreamViewModel(sourceStreamModel: sourceStreamModel,
        operationStreamModel: operationStreamModel)
        updateStreamViewModel.$operationStreamModel.dropFirst()
        .compactMap { $0 }
        .assign(to: \MultiStreamViewModel.operationStreamModel, on: self)
        .store(in: &self.disposeBag)
        return updateStreamViewModel
    }

    init(title: String, sourceStreamModel: StreamModel<String>, operationStreamModel: OperationStreamModel) {
        self.title = title
        self.operationStreamModel = operationStreamModel
        self.sourceStreamModel = sourceStreamModel
        $operationStreamModel
            .filter { $0 != nil }
            .map { operationStreamModel -> [StreamViewModel<[String]>] in
            let sourceViewModel = StreamViewModel(title: sourceStreamModel.name ?? "",
                                                       description: sourceStreamModel.sequenceDescription,
                                                       publisher: sourceStreamModel.toPublisher()).toArrayViewModel()
            var streamViewModels: [StreamViewModel<[String]>] = [sourceViewModel]
            var currentOperatorItem: Operator?  = operationStreamModel!.operatorItem
            var currentPublisher: AnyPublisher<String, Never>? = sourceStreamModel.toPublisher()
            while currentOperatorItem != nil {
                let newPublisher = currentOperatorItem!.applyPublisher(currentPublisher!)
                streamViewModels.append(StreamViewModel(title: currentOperatorItem!.description,
                                                             description: "",
                                                             publisher: newPublisher).toArrayViewModel())
                currentOperatorItem = currentOperatorItem?.next
                currentPublisher = newPublisher
            }
            return streamViewModels
        }.assign(to: \MultiStreamViewModel.streamViewModels, on: self)
        .store(in: &disposeBag)
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
