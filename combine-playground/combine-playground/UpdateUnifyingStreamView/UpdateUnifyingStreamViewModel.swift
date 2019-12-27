//
//  UpdateUnifyingStreamViewModel.swift
//  combine-playground
//
//  Created by kevin.cheng on 12/16/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
import CombineExtensions
import Combine
class UpdateUnifyingStreamViewModel: ObservableObject {

    let operators = ["merge", "flatMap", "append"]

    @Published var selectedOperator = "merge"

    @Published var title: String

    @Published var description: String

    @Published var sourceStreamModels: [StreamModel<String>]

    @Published var parameterTitle: String = ""

    @Published var unifyingStreamModel: UnifyingOperationStreamModel

    private var stagingStreamModel: UnifyingOperationStreamModel

    var disposables: DisposeBag = DisposeBag()

    convenience init(sourceStreamModels: [StreamModel<String>]) {
        self.init(sourceStreamModels: sourceStreamModels,
                  unifyingStreamModel:
            UnifyingOperationStreamModel(id: UUID(), name: nil,
                                         description: nil, operatorItem: .merge))
    }

    init(sourceStreamModels: [StreamModel<String>], unifyingStreamModel: UnifyingOperationStreamModel) {
        self.sourceStreamModels = sourceStreamModels
        self.unifyingStreamModel = unifyingStreamModel
        self.stagingStreamModel = unifyingStreamModel
        self.title = unifyingStreamModel.name ?? ""
        self.description = unifyingStreamModel.description ?? ""
        $selectedOperator.map {
            self.operators[self.operators.firstIndex(of: $0) ?? 0]
        }.assign(to: \UpdateUnifyingStreamViewModel.parameterTitle, on: self)
        .store(in: &disposables)

        switch unifyingStreamModel.operatorItem {
        case .merge:
            selectedOperator = "merge"
        case .flatMap:
            selectedOperator = "flatMap"
        case .append:
            selectedOperator = "append"
        }
        setupBindings()
    }

    func setupBindings() {
        Publishers.CombineLatest3($title, $description, $selectedOperator)
        .map { (title, description, selectedOpt) -> UnifyingOperationStreamModel in
            let opt: UnifyOparator
            switch selectedOpt {
            case "merge":
            opt = .merge
            case "flatMap":
            opt = .flatMap
            case "append":
            opt = .append
            default:
            opt = .append
            }
            return UnifyingOperationStreamModel(id: self.unifyingStreamModel.id, name: title,
                                                description: description, operatorItem: opt)
            }.assign(to: \.stagingStreamModel, on: self)
            .store(in: &disposables)
    }

    func save() {
        unifyingStreamModel = stagingStreamModel
    }
}
