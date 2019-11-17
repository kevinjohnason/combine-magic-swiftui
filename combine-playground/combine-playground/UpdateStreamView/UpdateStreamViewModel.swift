//
//  UpdateStreamViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/27/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

extension ClosedRange where Bound == Unicode.Scalar {
    static let asciiPrintable: ClosedRange = " "..."~"
    var range: ClosedRange<UInt32> { return lowerBound.value...upperBound.value }
    var scalars: [Unicode.Scalar] { return range.compactMap(Unicode.Scalar.init) }
    var characters: [Character] { return scalars.map(Character.init) }
    var string: String { return String(scalars) }
}

extension String {
    init<S: Sequence>(_ sequence: S) where S.Element == Unicode.Scalar {
        self.init(UnicodeScalarView(sequence))
    }
}

class UpdateStreamViewModel: ObservableObject {
    
    @Published var streamNumberOptions: [CircularTextViewModel]
    
    @Published var streamLetterOptions: [CircularTextViewModel]
        
    @Published var streamName: String
    
    @Published var streamDescription: String
        
    var sequenceDescription: String {
        streamModel.sequenceDescription
    }
    
    @Published var values: [TimeSeriesValue<String>]
    
    @Published var streamModel: StreamModel<String>
    
    private var disposables = Set<AnyCancellable>()
    
    init(streamModel: StreamModel<String>) {
        self.streamModel = streamModel
        self.streamNumberOptions = (1...8).map {
            print("generating \($0)")
            return CircularTextViewModel(value: String($0))
        }
        self.streamLetterOptions = ("A"..."H").characters.map {
            print("generating \($0)")
            return CircularTextViewModel(value: String($0))
        }
        self.streamName = streamModel.name ?? ""
        self.streamDescription = streamModel.sequenceDescription
        self.values = streamModel.stream.map {
            print("adding \($0.value) to tunnel")
            return TimeSeriesValue(value: $0.value)
        }
        self.setupDataBinding()
    }
    
    func setupDataBinding() {
        Publishers.CombineLatest($values, $streamName).map { (values, streamName) -> StreamModel<String> in
            var newStream = self.streamModel
            newStream.stream = values.map {
                StreamItem(value: $0.value, operatorItem: .delay(seconds: 1, next: nil))
            }
            newStream.name = streamName
            return newStream
        }.assign(to: \.streamModel, on: self)
        .store(in: &disposables)
    }
    
    func save() {
        var storedStreams = DataService.shared.storedStreams                        
        if let storedStreamIndex = storedStreams.firstIndex(where: { $0.id == self.streamModel.id }) {
            storedStreams[storedStreamIndex] = streamModel
        } else {
            storedStreams.append(streamModel)
        }
        DataService.shared.storedStreams = storedStreams
    }
    
}
