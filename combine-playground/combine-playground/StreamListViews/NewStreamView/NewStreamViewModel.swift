//
//  NewStreamViewModel.swift
//  combine-playground
//
//  Created by kevin.cheng on 12/26/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
import Combine
import CombineExtensions

class NewStreamViewModel: ObservableObject {
    let streamTitles: [String] = ["Stream Source", "Basic Operator", "Unifying Operator", "Join Operator"]
    @Published var selectedTitle: String = ""
    private var disposebles = DisposeSet()

    lazy var newStreamViewModel: UpdateStreamViewModel = {
        UpdateStreamViewModel(streamModel: StreamModel<String>.new())
    }()

    lazy var newOperationStreamViewModel: UpdateOperationStreamViewModel = {
        UpdateOperationStreamViewModel(sourceStreamModel: StreamModel<String>.new())
    }()

    lazy var newUnifyingStreamViewModel: UpdateUnifyingStreamViewModel = {
        UpdateUnifyingStreamViewModel(sourceStreamModels: [StreamModel<String>.new(), StreamModel<String>.new()])
    }()

    lazy var newJoinStreamViewModel: UpdateJoinStreamViewModel = {
        UpdateJoinStreamViewModel(sourceStreamModels: [StreamModel<String>.new(), StreamModel<String>.new()])
    }()
}
