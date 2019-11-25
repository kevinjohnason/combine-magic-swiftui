//
//  StreamStore.swift
//  combine-playground
//
//  Created by Kevin Cheng on 11/19/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import Foundation
import Combine
import CombineExtensions
class StreamStore: ObservableObject {
    @Published var streams: [StreamModel<String>] = DataService.shared.storedStreams

    @Published var operationStreams: [OperationStreamModel] = DataService.shared.storedOperationStreams

    var disposeBag = DisposeBag()

    init() {
        $streams.dropFirst().sink {
            DataService.shared.storedStreams = $0
        }.store(in: &disposeBag)
        $operationStreams.dropFirst().sink {
            DataService.shared.storedOperationStreams = $0
        }.store(in: &disposeBag)
    }

    var sourceStreams: [StreamModel<String>] {
        streams.filter { $0.isDefault }
    }

    var streamAModel: StreamModel<String> {
        sourceStreams.first ?? StreamModel<String>.new()
    }

    var streamBModel: StreamModel<String> {
        sourceStreams.last ?? StreamModel<String>.new()
    }

    var streamA: AnyPublisher<String, Never> {
        streamAModel.toPublisher()
    }

    var streamB: AnyPublisher<String, Never> {
        streamBModel.toPublisher()
    }

}
