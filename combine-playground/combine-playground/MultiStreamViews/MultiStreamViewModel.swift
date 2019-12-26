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
    var sourceStreamModels: [StreamModel<String>] = []
    @Published var operationStreamModel: OperationStreamModel?
    @Published var unifyingStreamModel: UnifyingOperationStreamModel?
    var title: String
    var disposeBag = DisposeBag()

    init(title: String, sourceStreamModel: StreamModel<String>, operationStreamModel: OperationStreamModel) {
        self.title = title
        self.operationStreamModel = operationStreamModel
        self.sourceStreamModels = [sourceStreamModel]
        $operationStreamModel
            .filter { $0 != nil }
            .map { $0! }
            .map { operationStreamModel -> [StreamViewModel<[String]>] in
            let sourceViewModel = StreamViewModel(title: sourceStreamModel.name ?? "",
                                                       description: sourceStreamModel.sequenceDescription,
                                                       publisher: sourceStreamModel.toPublisher()).toArrayViewModel()
            var streamViewModels: [StreamViewModel<[String]>] = [sourceViewModel]            
            var currentPublisher: AnyPublisher<String, Never> = sourceStreamModel.toPublisher()

            operationStreamModel.operators.forEach {
                let newPublisher = $0.applyPublisher(currentPublisher)
                streamViewModels.append(UpdatableStreamViewModel(updatableStreamModel: operationStreamModel,
                                                                 streamModel: sourceStreamModel,
                                                                 publisher: newPublisher).toArrayViewModel())
                currentPublisher = newPublisher
            }
            return streamViewModels
        }.assign(to: \MultiStreamViewModel.streamViewModels, on: self)
        .store(in: &disposeBag)
    }

    init(streamTitle: String, stream1Model: StreamModel<String>, stream2Model: StreamModel<String>,
         unifyingStreamModel: UnifyingOperationStreamModel) {
        self.title = streamTitle
        self.unifyingStreamModel = unifyingStreamModel
        $unifyingStreamModel
            .filter { $0 != nil }
            .map { $0! }
            .map { unifyingStreamModel -> [StreamViewModel<[String]>] in
                let stream1ViewModel = StreamViewModel(title: stream1Model.name ?? "",
                                                       description: stream1Model.sequenceDescription,
                    publisher: stream1Model.toPublisher()).toArrayViewModel()

                let stream2ViewModel = StreamViewModel(title: stream2Model.name ?? "",
                                                       description: stream2Model.sequenceDescription,
                    publisher: stream2Model.toPublisher()).toArrayViewModel()

                self.sourceStreamModels = [stream1Model, stream2Model]
                let operatorPublisher =
                    unifyingStreamModel.operatorItem.applyPublishers([stream1Model.toPublisher(),
                                                                      stream2Model.toPublisher()])

                let resultViewModel =  UpdatableStreamViewModel(updatableStreamModel: unifyingStreamModel,
                                                                streamModel: stream1Model,
                                                                publisher: operatorPublisher).toArrayViewModel()
                return [stream1ViewModel, stream2ViewModel, resultViewModel]
        }.assign(to: \MultiStreamViewModel.streamViewModels, on: self)
        .store(in: &disposeBag)
    }

    init(streamTitle: String, stream1Model: StreamModel<String>,
         stream2Model: StreamModel<String>, joinStreamModel: JoinOperationStreamModel) {
        title = streamTitle
        let stream1ViewModel: StreamViewModel<String> = DataStreamViewModel(streamModel: stream1Model)
        let stream2ViewModel: StreamViewModel<String> = DataStreamViewModel(streamModel: stream2Model)
        let operatorPublisher =
            joinStreamModel.operatorItem.applyPublishers([stream1Model.toPublisher(), stream2Model.toPublisher()])
        let resultStreamViewModel = UpdatableStreamViewModel(updatableStreamModel: joinStreamModel,
                                                             streamModel: stream1Model.toArrayStreamModel(),
                                                             publisher: operatorPublisher)

        streamViewModels = [stream1ViewModel.toArrayViewModel(),
                            stream2ViewModel.toArrayViewModel(),
                            resultStreamViewModel]
    }
}
