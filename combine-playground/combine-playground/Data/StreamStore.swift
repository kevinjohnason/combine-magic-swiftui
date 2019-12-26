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

    @Published var operationStreams = DataService.shared.storedOperationStreams

    @Published var unifyingStreams = DataService.shared.storedUnifyingOperationStreams

    @Published var joinStreams = DataService.shared.storedJoinOperationStreams

    var disposeBag = DisposeBag()

    init() {
        $streams.dropFirst().sink {
            DataService.shared.storedStreams = $0
        }.store(in: &disposeBag)

        $operationStreams.dropFirst().sink {
            DataService.shared.storedOperationStreams = $0
        }.store(in: &disposeBag)

        $unifyingStreams.dropFirst().sink {
            DataService.shared.storedUnifyingOperationStreams = $0
        }.store(in: &disposeBag)

        $joinStreams.dropFirst().sink {
            DataService.shared.storedJoinOperationStreams = $0
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

    func save(_ streamModel: StreamModel<String>) {
        var storedStreams = streams
        if let storedStreamIndex = storedStreams.firstIndex(where: { $0.id == streamModel.id }) {
            storedStreams[storedStreamIndex] = streamModel
        } else {
            storedStreams.append(streamModel)
        }
        streams = storedStreams
    }

    func save(_ operationStreamModel: OperationStreamModel) {
        var storedOperations = operationStreams
        if let storedStreamIndex = storedOperations.firstIndex(where: { $0.id == operationStreamModel.id }) {
            storedOperations[storedStreamIndex] = operationStreamModel
        } else {
            storedOperations.append(operationStreamModel)
        }
        operationStreams = storedOperations
    }

    func save(_ operationStreamModel: UnifyingOperationStreamModel) {
        var storedOperations = unifyingStreams
        if let storedStreamIndex = storedOperations.firstIndex(where: { $0.id == operationStreamModel.id }) {
            storedOperations[storedStreamIndex] = operationStreamModel
        } else {
            storedOperations.append(operationStreamModel)
        }
        unifyingStreams = storedOperations
    }
}
