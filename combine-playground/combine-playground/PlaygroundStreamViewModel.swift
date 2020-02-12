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

        let scanPublisher = TransformingOperator.scan(initialValue: 0, expression: "%d + %d").applyPublisher(publisher)
        let scanStreamViewModel = StreamViewModel(title: "Scan Result",
                                                  description: ".scan(0) { %d + %d }", publisher: scanPublisher)
        let mapPublisher = TransformingOperator<Int>.map(expression: "%d * 2").applyPublisher(scanPublisher)
        let mapStreamViewModel = StreamViewModel(title: "Map Result",
                                                 description: ".map { %d * 2 }", publisher: mapPublisher)
        multiStreamViewModel = MultiStreamViewModel(title: "Playground",
                                                    streamViewModels: [sourceStreamViewModel,
                                                                       scanStreamViewModel, mapStreamViewModel])
    }
}
