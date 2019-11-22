//
//  ContentViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/30/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {

    private var disposables = Set<AnyCancellable>()        

    @Published var storedOperationStreams: [OperationStreamModel] = DataService.shared.storedOperationStreams

    @Published var storedUnifyingOperationStreams: [UnifyingOperationStreamModel] =
        DataService.shared.storedUnifyingOperationStreams

    @Published var storedCombineGroupOperationStreams: [JoinOperationStreamModel] =
        DataService.shared.storedCombineGroupOperationStreams

    var cancellable: Cancellable?

    init() {
        refresh()
    }

    func refresh() {

        DataService.shared.storedOperationStreamUpdated.sink { (newStream) in
            self.storedOperationStreams = newStream
        }.store(in: &disposables)

        DataService.shared.storedUnifyingOperationStreamUpdated.sink { (newStream) in
            self.storedUnifyingOperationStreams = newStream
        }.store(in: &disposables)

        DataService.shared.storedCombineGroupOperationStreamUpdated.sink { (newStream) in
            self.storedCombineGroupOperationStreams = newStream
        }.store(in: &disposables)
    }

}
