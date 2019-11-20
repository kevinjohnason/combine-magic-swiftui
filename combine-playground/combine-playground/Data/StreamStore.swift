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
    
    var streamAModel: StreamModel<String> {
        streams.first(where: { $0.isDefault }) ?? StreamModel<String>.new()
    }

    var streamBModel: StreamModel<String> {
        streams.last(where: { $0.isDefault }) ?? StreamModel<String>.new()
    }
    
    var streamA: AnyPublisher<String, Never> {
        streamAModel.toPublisher()
    }

    var streamB: AnyPublisher<String, Never> {
        streamBModel.toPublisher()
    }
}
