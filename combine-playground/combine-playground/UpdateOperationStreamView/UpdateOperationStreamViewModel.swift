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

    let updateIndex: Int

    var disposables: DisposeSet = DisposeSet()

    convenience init(sourceStreamModel: StreamModel<String>) {
        let newOperationStreamModel = OperationStreamModel(id: UUID(), name: nil,
                                                           description: nil,
                                                           operators: [])
        self.init(sourceStreamModel: sourceStreamModel,
                  operationStreamModel: newOperationStreamModel, updateIndex: 0)
    }

    init(sourceStreamModel: StreamModel<String>, operationStreamModel: OperationStreamModel, updateIndex: Int) {
        self.sourceStreamModel = sourceStreamModel
        self.operationStreamModel = operationStreamModel
        self.stagingOperationStreamModel = operationStreamModel
        self.updateIndex = updateIndex
        $selectedOperator.map {
            self.parameterTitles[self.operators.firstIndex(of: $0) ?? 0]
        }.assign(to: \UpdateOperationStreamViewModel.parameterTitle, on: self)
            .store(in: &disposables)
        title = operationStreamModel.name ?? ""
        description = operationStreamModel.description ?? ""

        if operationStreamModel.operators.count > updateIndex {
            switch operationStreamModel.operators[updateIndex] {
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
        }
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
                var currentOperators = self.operationStreamModel.operators
                if currentOperators.count > self.updateIndex {
                    currentOperators[self.updateIndex] = $0.2
                } else {
                    currentOperators.append($0.2)
                }
                return OperationStreamModel(id: self.operationStreamModel.id,
                                            name: $0.0, description: $0.1, operators: currentOperators)
        }.assign(to: \.stagingOperationStreamModel, on: self)
        .store(in: &disposables)
    }

    func save() {
        operationStreamModel = stagingOperationStreamModel
    }
}
