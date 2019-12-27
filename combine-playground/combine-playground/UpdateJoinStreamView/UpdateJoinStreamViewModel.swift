//
//  UpdateJoinStreamViewModel.swift
//  combine-playground
//
//  Created by kevin.cheng on 11/20/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import Foundation
import Combine
import CombineExtensions
class UpdateJoinStreamViewModel: ObservableObject {
    let operators = ["zip", "combine_latest"]

    @Published var selectedOperator = "zip"

    @Published var title: String

    @Published var description: String

    @Published var sourceStreamModels: [StreamModel<String>]

    @Published var parameterTitle: String = ""

    @Published var operationModel: JoinOperationStreamModel

    private var stagingOperationModel: JoinOperationStreamModel

    var disposables: DisposeBag = DisposeBag()

    convenience init(sourceStreamModels: [StreamModel<String>]) {
        self.init(sourceStreamModels: sourceStreamModels,
                  operationModel: JoinOperationStreamModel(id: UUID(), name: nil, description: nil,
                                                           operatorItem: .zip))
    }

    init(sourceStreamModels: [StreamModel<String>], operationModel: JoinOperationStreamModel) {
        self.sourceStreamModels = sourceStreamModels
        self.operationModel = operationModel
        self.stagingOperationModel = operationModel
        self.title = operationModel.name ?? ""
        self.description = operationModel.description ?? ""
        $selectedOperator.map {
            self.operators[self.operators.firstIndex(of: $0) ?? 0]
        }.assign(to: \.parameterTitle, on: self)
        .store(in: &disposables)

        switch operationModel.operatorItem {
        case .zip:
            selectedOperator = "zip"
        case .combineLatest:
            selectedOperator = "combine_latest"
        }
        setupBindings()
    }

    func setupBindings() {
        Publishers.CombineLatest3($title, $description, $selectedOperator)
        .map { (title, description, selectedOpt) -> JoinOperationStreamModel in
            let opt: JoinOperator
            switch selectedOpt {
            case "zip":
                opt = .zip
            case "flatMap":
            opt = .combineLatest
            default:
            opt = .zip
            }
            return JoinOperationStreamModel(id: self.operationModel.id, name: title,
                                            description: description, operatorItem: opt)
            }.assign(to: \.stagingOperationModel, on: self)
            .store(in: &disposables)
    }

    func save() {
        operationModel = stagingOperationModel
    }
}
