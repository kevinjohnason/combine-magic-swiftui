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
    
    @Published var storedStreams: [StreamModel<String>] = DataService.shared.storedStreams
    
    @Published var storedOperationStreams: [OperationStreamModel] = DataService.shared.storedOperationStreams
             
    @Published var storedGroupOperationStreams: [GroupOperationStreamModel] = DataService.shared.storedGroupOperationStreams
    
    @Published var storedCombineGroupOperationStreams: [CombineGroupOperationStreamModel] = DataService.shared.storedCombineGroupOperationStreams
    
    var streamAModel: StreamModel<String> {
        storedStreams.first(where: { $0.isDefault }) ?? StreamModel<String>.new()
    }
    
    var streamBModel: StreamModel<String> {
        storedStreams.last(where: { $0.isDefault }) ?? StreamModel<String>.new()
    }
    
    var streamA: AnyPublisher<String, Never> {
        streamAModel.toPublisher()
    }
    
    var streamB: AnyPublisher<String, Never> {
        streamBModel.toPublisher()
    }
    
    var cancellable: Cancellable?
    
    init() {
        refresh()
    }
    
    func refresh() {
        DataService.shared.storedStreamUpdated.sink { (newStream) in
            self.storedStreams = newStream
        }.store(in: &disposables)
        
        DataService.shared.storedOperationStreamUpdated.sink { (newStream) in
            self.storedOperationStreams = newStream
        }.store(in: &disposables)
        
        DataService.shared.storedGroupOperationStreamUpdated.sink { (newStream) in
            self.storedGroupOperationStreams = newStream
        }.store(in: &disposables)
        
        DataService.shared.storedCombineGroupOperationStreamUpdated.sink { (newStream) in
            self.storedCombineGroupOperationStreams = newStream
        }.store(in: &disposables)
    }
    
}
