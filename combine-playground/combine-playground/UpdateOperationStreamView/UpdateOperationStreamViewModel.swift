//
//  UpdateOperationStreamViewModel.swift
//  combine-playground
//
//  Created by kevin.cheng on 11/20/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import Foundation
import Combine

class UpdateOperationStreamViewModel: ObservableObject {

    let operators = ["filter", "dropFirst", "map", "scan"]

    let parameterTitles = ["Expression", "Count", "Expression", "Expression"]

    @Published var selectedOperator = "filter"

    @Published var parameter: String = ""

    @Published var parameterTitle: String = ""

    @Published var title: String = ""

    @Published var description = ""

    @Published var streamStore: StreamStore

    var operationStreamModel: OperationStreamModel

    var disposables: Set<AnyCancellable> = Set()

    convenience init(streamStore: StreamStore) {
        let newOperationStreamModel = OperationStreamModel(id: UUID(), name: nil,
                                                           description: nil,
                                                           operatorItem: .delay(seconds: 0, next: nil))
        self.init(streamStore: streamStore, operationStreamModel: newOperationStreamModel)
    }

    init(streamStore: StreamStore, operationStreamModel: OperationStreamModel) {
        self.streamStore = streamStore
        self.operationStreamModel = operationStreamModel
        $selectedOperator.map {
            self.parameterTitles[self.operators.firstIndex(of: $0) ?? 0]
        }.assign(to: \UpdateOperationStreamViewModel.parameterTitle, on: self)
        .store(in: &disposables)

        switch operationStreamModel.operatorItem {
        case .delay:
            selectedOperator = "delay"
        case .dropFirst(let count, _):
            selectedOperator = "dropFirst"
            parameter = String(count)
        case .filter(let expression, _):
            selectedOperator = "filter"
            parameter = expression
        case .map(let expression, _):
            selectedOperator = "map"
            parameter = expression
        case .scan(let expression, _):
            selectedOperator = "scan"
            parameter = expression
        }
        title = operationStreamModel.name ?? ""
        description = operationStreamModel.description ?? ""
    }

    func save() {
        operationStreamModel.name = title
        operationStreamModel.description = description
        switch selectedOperator {
        case "filter":
            operationStreamModel.operatorItem = .filter(expression: parameter, next: nil)
        case "dropFirst":
            operationStreamModel.operatorItem = .dropFirst(count: Int(parameter) ?? 0, next: nil)
        case "map":
            operationStreamModel.operatorItem = .map(expression: parameter, next: nil)
        case "scan":
            operationStreamModel.operatorItem = .scan(expression: parameter, next: nil)
        default:
            break
        }
    }
}
