//
//  UpdateUnifyingStreamViewModel.swift
//  combine-playground
//
//  Created by kevin.cheng on 12/16/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
import CombineExtensions

class UpdateUnifyingStreamViewModel: ObservableObject {

    let operators = ["merge", "flatMap", "append"]

    @Published var selectedOperator = "merge"

    @Published var title: String

    @Published var description: String

    @Published var sourceStreamModels: [StreamModel<String>]

    @Published var parameterTitle: String = ""

    @Published var unifyingStreamModel: UnifyingOperationStreamModel

    var disposables: DisposeBag = DisposeBag()

    init(sourceStreamModels: [StreamModel<String>], unifyingStreamModel: UnifyingOperationStreamModel) {
        self.sourceStreamModels = sourceStreamModels
        self.unifyingStreamModel = unifyingStreamModel
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
    }

    func updateStreamModel() {
        unifyingStreamModel.name = title
        unifyingStreamModel.description = description
        switch selectedOperator {
        case "merge":
            unifyingStreamModel.operatorItem = .merge(next: nil)
        case "flatMap":
            unifyingStreamModel.operatorItem = .flatMap(next: nil)
        case "append":
            unifyingStreamModel.operatorItem = .append(next: nil)
        default:
            break
        }
    }
}
