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

    var updatableIndex: Int

    private var disposables = DisposeSet()

    lazy var updateOperationStreamViewModel: UpdateOperationStreamViewModel? = {
        guard let stringStreamModel = sourceStreamModel as? StreamModel<[String]>,
        let updateStreamModel = updateStreamModel as? OperationStreamModel<String> else {
            return nil
        }
        let updateStreamViewModel = UpdateOperationStreamViewModel(
            sourceStreamModel: stringStreamModel.flatMapModel(),
            operationStreamModel: updateStreamModel,
            updateIndex: self.updatableIndex)
        updateStreamViewModel.$operationStreamModel.map {
            $0.operators.count > self.updatableIndex ?
                $0.operators[self.updatableIndex].description : ""
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

    lazy var updateJoinStreamViewModel: UpdateJoinStreamViewModel? = {
        guard let stringStreamModel = sourceStreamModel as? StreamModel<[String]>,
        let joinStreamModel = updateStreamModel as? JoinOperationStreamModel else {
            return nil
        }
        let updateUnifyingStreamViewModel =
            UpdateJoinStreamViewModel(sourceStreamModels: [stringStreamModel.flatMapModel()],
                                      operationModel: joinStreamModel)

        updateUnifyingStreamViewModel.$operationModel
            .map { $0.name ?? "" }
            .assign(to: \.title, on: self)
            .store(in: &self.disposables)
        updateUnifyingStreamViewModel.$operationModel
            .map { $0.description ?? "" }
            .assign(to: \.description, on: self)
            .store(in: &self.disposables)
        return updateUnifyingStreamViewModel
    }()

    init(updatableStreamModel: Updatable,
         updatableIndex: Int,
         streamModel: StreamModel<T>,
         publisher: AnyPublisher<T, Never>) {
        self.updateStreamModel = updatableStreamModel
        self.sourceStreamModel = streamModel
        self.updatableIndex = updatableIndex
        if let operationStreamModel = updatableStreamModel as? OperationStreamModel<T>,
            operationStreamModel.operators.count > updatableIndex {
            super.init(title: operationStreamModel.operators[updatableIndex].description,
                              description: "", publisher: publisher, editable: true)
        } else {
            super.init(title: updatableStreamModel.name ?? "",
                       description: updatableStreamModel.description ?? "", publisher: publisher, editable: true)
        }
    }

    override func toArrayViewModel() -> StreamViewModel<[T]> {
        return UpdatableStreamViewModel<[T]>(
            updatableStreamModel: self.updateStreamModel,
            updatableIndex: self.updatableIndex,
            streamModel: sourceStreamModel.toArrayStreamModel(),
            publisher: self.publisher.map { [$0] }.eraseToAnyPublisher())
    }
}
