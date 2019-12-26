//
//  UpdateOperationStreamViewModel.swift
//  combine-playground
//
//  Created by kevin.cheng on 11/20/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import Foundation
import Combine
import CombineExtensions
class UpdateOperationStreamViewModel: ObservableObject {

    let operators = ["filter", "dropFirst", "map", "scan"]

    let parameterTitles = ["Expression", "Count", "Expression", "Expression"]

    @Published var selectedOperator = "filter"

    @Published var parameter: String = ""

    @Published var parameterTitle: String = ""

    @Published var title: String = ""

    @Published var description = ""

    @Published var sourceStreamModel: StreamModel<String>

    @Published var operationStreamModel: OperationStreamModel

    var stagingOperationStreamModel: OperationStreamModel

    var disposables: DisposeBag = DisposeBag()

    convenience init(sourceStreamModel: StreamModel<String>) {
        let newOperationStreamModel = OperationStreamModel(id: UUID(), name: nil,
                                                           description: nil,
                                                           operators: [.delay(seconds: 0)])
        self.init(sourceStreamModel: sourceStreamModel, operationStreamModel: newOperationStreamModel)
    }

    // kevin todo: Take operator instead of OperationStreamModel
    init(sourceStreamModel: StreamModel<String>, operationStreamModel: OperationStreamModel) {
        self.sourceStreamModel = sourceStreamModel
        self.operationStreamModel = operationStreamModel
        self.stagingOperationStreamModel = operationStreamModel
        $selectedOperator.map {
            self.parameterTitles[self.operators.firstIndex(of: $0) ?? 0]
        }.assign(to: \UpdateOperationStreamViewModel.parameterTitle, on: self)
        .store(in: &disposables)


        switch operationStreamModel.operators.first! {
        case .delay:
            selectedOperator = "delay"
        case .dropFirst(let count):
            selectedOperator = "dropFirst"
            parameter = String(count)
        case .filter(let expression):
            selectedOperator = "filter"
            parameter = expression
        case .map(let expression):
            selectedOperator = "map"
            parameter = expression
        case .scan(let expression):
            selectedOperator = "scan"
            parameter = expression
        }
        title = operationStreamModel.name ?? ""
        description = operationStreamModel.description ?? ""
        setupBindings()
    }

    func setupBindings() {
        let opt = $selectedOperator.combineLatest($parameter)
            .map { (selectedOperator, parameter) -> Operator in
                switch selectedOperator {
                case "filter":
                    return .filter(expression: parameter)
                case "dropFirst":
                    return .dropFirst(count: Int(parameter) ?? 0)
                case "map":
                    return .map(expression: parameter)
                case "scan":
                    return .scan(expression: parameter)
                default:
                    return .filter(expression: parameter)
                }
            }
        Publishers.CombineLatest3($title, $description, opt)
            .map {
                //kevin todo: update operator array by replacing the modifying operator
                OperationStreamModel(id: self.operationStreamModel.id, name: $0.0,
                                     description: $0.1, operators: [$0.2])
            }.print("stream_model")
        .assign(to: \.stagingOperationStreamModel, on: self)
        .store(in: &disposables)
    }

    func save() {
        operationStreamModel = stagingOperationStreamModel
    }
}
