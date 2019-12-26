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

    var sourceStreamModel: StreamModel<T>

    var updateStreamModel: Updatable

    private var disposables = DisposeBag()

    lazy var updateOperationStreamViewModel: UpdateOperationStreamViewModel? = {
        guard let stringStreamModel = sourceStreamModel as? StreamModel<[String]>,
        let updateStreamModel = updateStreamModel as? OperationStreamModel else {
            return nil
        }
        let updateStreamViewModel = UpdateOperationStreamViewModel(sourceStreamModel: stringStreamModel.flatMapModel(),
        operationStreamModel: updateStreamModel)
        updateStreamViewModel.$operationStreamModel.map {
            $0.operatorItem.description
        }.assign(to: \.title, on: self).store(in: &disposables)
        return updateStreamViewModel
    }()

    lazy var updateUnifyingStreamViewModel: UpdateUnifyingStreamViewModel? = {
        guard let stringStreamModel = sourceStreamModel as? StreamModel<[String]>,
        let unifyingStreamModel = updateStreamModel as? UnifyingOperationStreamModel else {
            return nil
        }
        let updateUnifyingStreamViewModel =
            UpdateUnifyingStreamViewModel(sourceStreamModels: [stringStreamModel.flatMapModel()],
                                          unifyingStreamModel: unifyingStreamModel)
        updateUnifyingStreamViewModel.$unifyingStreamModel
            .map { $0.name ?? "" }
            .assign(to: \.title, on: self)
            .store(in: &self.disposables)
        
        updateUnifyingStreamViewModel.$unifyingStreamModel
            .map { $0.description ?? "" }
            .assign(to: \.description, on: self)
            .store(in: &self.disposables)
        return updateUnifyingStreamViewModel
    }()

    init(updatableStreamModel: Updatable,
         streamModel: StreamModel<T>,
         publisher: AnyPublisher<T, Never>) {
        self.updateStreamModel = updatableStreamModel
        self.sourceStreamModel = streamModel
        if let operationStreamModel = updatableStreamModel as? OperationStreamModel {
            super.init(title: operationStreamModel.operatorItem.description,
                              description: "", publisher: publisher, editable: true)
        } else {
            super.init(title: updatableStreamModel.name ?? "",
                       description: updatableStreamModel.description ?? "", publisher: publisher, editable: true)
        }
    }

    override func toArrayViewModel() -> StreamViewModel<[T]> {
        return UpdatableStreamViewModel<[T]>(
            updatableStreamModel: self.updateStreamModel,
            streamModel: sourceStreamModel.toArrayStreamModel(),
            publisher: self.publisher.map { [$0] }.eraseToAnyPublisher())
    }
}
