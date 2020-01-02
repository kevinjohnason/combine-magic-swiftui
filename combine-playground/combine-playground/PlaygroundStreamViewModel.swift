//
//  PlaygroundViewModel.swift
//  combine-playground
//
//  Created by Kevin Cheng on 12/31/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
import Combine
class PlaygroundStreamViewModel: ObservableObject {
    var multiStreamViewModel: MultiStreamViewModel

    let streamStore: StreamStore

    init(streamStore: StreamStore) {
        self.streamStore = streamStore

        let streamA = (1...4).map { StreamItem(value: $0,
                                               operators: [.delay(seconds: 1)]) }
        let serialStreamA = StreamModel(id: UUID(), name: "Serial Stream A",
                                        description: nil, stream: streamA, isDefault: true)

        let publisher = serialStreamA.toPublisher()
        let sourceStreamViewModel = StreamViewModel(title: "Source Stream", publisher: publisher)

        let playgroundStreamViewModel = StreamViewModel(title: "Playground Result",
                                                    publisher: PlaygroundStreamViewModel.applyToPublisher(publisher))
        multiStreamViewModel = MultiStreamViewModel(title: "Playground",
                                                    streamViewModels: [sourceStreamViewModel,
                                                                       playgroundStreamViewModel])

    }

    static func applyToPublisher<T>(_ publisher: AnyPublisher<T, Never>) -> AnyPublisher<T, Never> {
        Operator.map(expression: "%d * 2").applyPublisher(publisher)
    }

}
