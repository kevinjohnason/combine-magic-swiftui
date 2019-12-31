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

    init(streamStore: StreamStore) {
        let sourceStreamModel = streamStore.sourceStreams[0]
        let publisher = sourceStreamModel.toPublisher()
        let sourceStreamViewModel = StreamViewModel(title: "Source Stream", publisher: publisher)

        let playgroundStreamViewModel = StreamViewModel(title: "Playground Result",
                                                    publisher: PlaygroundStreamViewModel.applyToPublisher(publisher))
        multiStreamViewModel = MultiStreamViewModel(title: "Playground",
                                                    streamViewModels: [sourceStreamViewModel,
                                                                       playgroundStreamViewModel])

    }

    static func applyToPublisher(_ publisher: AnyPublisher<String, Never>) -> AnyPublisher<String, Never> {
        return publisher.map { (Int($0) ?? 0) + 1 }.map { String($0) }.eraseToAnyPublisher()
    }

}
