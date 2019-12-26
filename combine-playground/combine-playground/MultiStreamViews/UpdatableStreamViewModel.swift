//
//  UpdatableStreamViewModel.swift
//  combine-playground
//
//  Created by Kevin Cheng on 12/24/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import Foundation
import Combine
import CombineExtensions

class UpdatableStreamViewModel<T: Codable>: StreamViewModel<T> {

    var streamModel: StreamModel<T>

    var operationStreamModel: OperationStreamModel

    private var disposables = DisposeBag()

    lazy var updateOperationStreamViewModel: UpdateOperationStreamViewModel? = {
        guard let stringStreamModel = streamModel as? StreamModel<[String]> else {
            return nil
        }
        let updateStreamViewModel = UpdateOperationStreamViewModel(sourceStreamModel: stringStreamModel.flatMapModel(),
        operationStreamModel: operationStreamModel)
        updateStreamViewModel.$operationStreamModel.map {
            $0.operatorItem.description
        }.assign(to: \.title, on: self).store(in: &disposables)
        return updateStreamViewModel
    }()

    init(operationStreamModel: OperationStreamModel,
         streamModel: StreamModel<T>,
         publisher: AnyPublisher<T, Never>) {
        self.operationStreamModel = operationStreamModel
        self.streamModel = streamModel
        super.init(title: operationStreamModel.operatorItem.description,
                   description: "", publisher: publisher, editable: true)
    }

    override func toArrayViewModel() -> StreamViewModel<[T]> {
        return UpdatableStreamViewModel<[T]>(
            operationStreamModel: self.operationStreamModel,
            streamModel: streamModel.toArrayStreamModel(),
            publisher: self.publisher.map { [$0] }.eraseToAnyPublisher())
    }
}
