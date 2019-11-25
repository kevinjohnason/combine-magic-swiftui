//
//  DataService.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/28/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import Combine
class DataService {
    static let shared = DataService()
    var storedStreams: [StreamModel<String>] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "storedStreams") else {
                return self.appendDefaultStreamsIfNeeded(streams: [])
            }
            guard let streams = try? JSONDecoder().decode([StreamModel<String>].self, from: data) else {
                return self.appendDefaultStreamsIfNeeded(streams: [])
            }
            return self.appendDefaultStreamsIfNeeded(streams: streams)
        } set {
            // swiftlint:disable:next force_try
            UserDefaults.standard.set(try! JSONEncoder().encode(newValue), forKey: "storedStreams")
        }
    }

    var storedOperationStreams: [OperationStreamModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "storedOperationStreams") else {
                return self.appendDefaultOperationStreamsIfNeeded(streams: [])
            }
            guard let streams = try? JSONDecoder().decode([OperationStreamModel].self, from: data) else {
                return self.appendDefaultOperationStreamsIfNeeded(streams: [])
            }
            return self.appendDefaultOperationStreamsIfNeeded(streams: streams)
        } set {
            // swiftlint:disable:next force_try
            UserDefaults.standard.set(try! JSONEncoder().encode(newValue), forKey: "storedOperationStreams")
        }
    }

    var storedUnifyingOperationStreams: [UnifyingOperationStreamModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "storedUnifyingOperationStreams") else {
                return self.appendDefaultUnifyingOperationStreamsIfNeeded(streams: [])
            }
            guard let streams = try? JSONDecoder().decode([UnifyingOperationStreamModel].self, from: data) else {
                return self.appendDefaultUnifyingOperationStreamsIfNeeded(streams: [])
            }
            return self.appendDefaultUnifyingOperationStreamsIfNeeded(streams: streams)
        } set {
            // swiftlint:disable:next force_try
            UserDefaults.standard.set(try! JSONEncoder().encode(newValue), forKey: "storedUnifyingOperationStreams")
            storedUnifyingOperationStreamUpdated.send(newValue)
        }
    }

    var storedCombineGroupOperationStreams: [JoinOperationStreamModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "storedCombineGroupOperationStreams") else {
                return self.appendDefaultCombineGroupOperationStreamsIfNeeded(streams: [])
            }
            guard let streams = try? JSONDecoder().decode([JoinOperationStreamModel].self, from: data) else {
                return self.appendDefaultCombineGroupOperationStreamsIfNeeded(streams: [])
            }
            return self.appendDefaultCombineGroupOperationStreamsIfNeeded(streams: streams)
        } set {
            // swiftlint:disable:next force_try
            UserDefaults.standard.set(try! JSONEncoder().encode(newValue), forKey: "storedCombineGroupOperationStreams")
            storedCombineGroupOperationStreamUpdated.send(newValue)
        }
    }
    let storedUnifyingOperationStreamUpdated: PassthroughSubject<[UnifyingOperationStreamModel], Never>
        = PassthroughSubject()
    let storedCombineGroupOperationStreamUpdated: PassthroughSubject<[JoinOperationStreamModel], Never>
        = PassthroughSubject()
    // swiftlint:disable identifier_name
    func loadStream(id: UUID) -> StreamModel<String> {
        guard let stream = DataService.shared.storedStreams.first(where: {
            $0.id == id
        }) else {
            return StreamModel<String>.new()
        }
        return stream
    }

    func appendDefaultStreamsIfNeeded(streams: [StreamModel<String>]) -> [StreamModel<String>] {
        guard (streams.filter { $0.isDefault }).count == 0 else {
            return streams
        }

        let streamA = (1...4).map { StreamItem(value: String($0),
                                               operatorItem: .delay(seconds: 1, next: nil)) }
        let serialStreamA = StreamModel(id: UUID(), name: "Serial Stream A",
                                        description: nil, stream: streamA, isDefault: true)

        let streamB = ["A", "B", "C", "D"].map {
            StreamItem(value: $0, operatorItem: .delay(seconds: 2, next: nil)) }
        let serialStreamB = StreamModel(id: UUID(), name: "Serial Stream B",
                                        description: nil, stream: streamB, isDefault: true)

        var newStreams = streams
        newStreams.append(serialStreamA)
        newStreams.append(serialStreamB)
        self.storedStreams = newStreams
        return newStreams
    }

    func appendDefaultOperationStreamsIfNeeded(streams: [OperationStreamModel]) -> [OperationStreamModel] {
        guard streams.count == 0 else {
            return streams
        }

        let filterStreamModel = OperationStreamModel(id: UUID(),
                                                     name: "Filter Stream", description: "filter { $0 != 3 )",
                                                     operatorItem: .filter(expression: "%d != 3", next: nil))

        let dropStreamModel = OperationStreamModel(id: UUID(), name: "Drop Stream", description: "dropFirst(2)",
                                                   operatorItem: .dropFirst(count: 2, next: nil))

        let mapStreamModel = OperationStreamModel(id: UUID(), name: "Map Stream", description: "map { $0 * 2 }",
                                                  operatorItem: .map(expression: "%d * 2", next: nil))

        let scanStreamModel = OperationStreamModel(id: UUID(), name: "Scan Stream",
                                                   description: "scan(0) { $0 + $1 }",
                                                   operatorItem: .scan(expression: "%d + %d", next: nil))

        let mixedStreamModel = OperationStreamModel(id: UUID(), name: "Map then Scan",
                                                  description: "map { $0 * 2 }.scan(0) { $0 + $1 }",
                                                  operatorItem: .map(expression: "%d * 2", next:
                                                    .scan(expression: "%d + %d", next: nil)))

        var newStreams = streams
        newStreams.append(filterStreamModel)
        newStreams.append(dropStreamModel)
        newStreams.append(mapStreamModel)
        newStreams.append(scanStreamModel)
        newStreams.append(mixedStreamModel)
        return newStreams
    }

    func appendDefaultUnifyingOperationStreamsIfNeeded(streams: [UnifyingOperationStreamModel])
        -> [UnifyingOperationStreamModel] {
        let mergeStreamModel = UnifyingOperationStreamModel(id: UUID(), name: "Merge Stream",
                                                         description: "Publishers.merge(A, B)",
                                                         operatorItem: .merge(next: nil))
        let flatMapStreamModel = UnifyingOperationStreamModel(id: UUID(),
                                                           name: "FlatMap Stream",
                                                           description: "A.flatMap { _ in B }",
                                                           operatorItem: .flatMap(next: nil))
        let appendStreamModel = UnifyingOperationStreamModel(id: UUID(), name: "Append Stream",
                                                          description: "A.append(B)",
                                                          operatorItem: .append(next: nil))
        return [mergeStreamModel, flatMapStreamModel, appendStreamModel]
    }

    func appendDefaultCombineGroupOperationStreamsIfNeeded(streams: [JoinOperationStreamModel])
        -> [JoinOperationStreamModel] {
        let zipStreamModel = JoinOperationStreamModel(id: UUID(),
                                                      name: "Zip Stream", description: "Publishers.Zip(A, B)",
                                                      operatorItem: .zip)
        let combineLatestStreamModel = JoinOperationStreamModel(id: UUID(),
                                                                        name: "CombineLatest Stream",
                                                                        description: "Publishers.CombineLatest(A, B)",
                                                                        operatorItem: .combineLatest)
        return [zipStreamModel, combineLatestStreamModel]
    }
    func resetStoredStream() {
        storedStreams = appendDefaultStreamsIfNeeded(streams: [])
        storedOperationStreams = appendDefaultOperationStreamsIfNeeded(streams: [])
        storedUnifyingOperationStreams = appendDefaultUnifyingOperationStreamsIfNeeded(streams: [])
        storedCombineGroupOperationStreams = appendDefaultCombineGroupOperationStreamsIfNeeded(streams: [])
    }
}
