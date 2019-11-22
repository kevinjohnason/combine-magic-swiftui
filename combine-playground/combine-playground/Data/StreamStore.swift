//
//  StreamStore.swift
//  combine-playground
//
//  Created by Kevin Cheng on 11/19/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import Foundation
import Combine
class StreamStore: ObservableObject {
    @Published var streams: [StreamModel<String>] = DataService.shared.storedStreams

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
