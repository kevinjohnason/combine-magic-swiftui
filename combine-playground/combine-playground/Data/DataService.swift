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

    var storedTransformingOperationStreams: [TransformingOperationStreamModel<Int>] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "storedTransformingOperationStreams") else {
                return self.appendDefaultTransformingOperationStreamsIfNeeded(streams: [])
            }
            guard let streams = try? JSONDecoder().decode([TransformingOperationStreamModel<Int>].self,
                                                          from: data) else {
                return self.appendDefaultTransformingOperationStreamsIfNeeded(streams: [])
            }
            return self.appendDefaultTransformingOperationStreamsIfNeeded(streams: streams)
        } set {
            // swiftlint:disable:next force_try
            UserDefaults.standard.set(try! JSONEncoder().encode(newValue), forKey: "storedTransformingOperationStreams")
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

    var storedJoinOperationStreams: [JoinOperationStreamModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "storedJoinOperationStreams") else {
                return self.appendDefaultJoinOperationStreamsIfNeeded(streams: [])
            }
            guard let streams = try? JSONDecoder().decode([JoinOperationStreamModel].self, from: data) else {
                return self.appendDefaultJoinOperationStreamsIfNeeded(streams: [])
            }
            return self.appendDefaultJoinOperationStreamsIfNeeded(streams: streams)
        } set {
            // swiftlint:disable:next force_try
            UserDefaults.standard.set(try! JSONEncoder().encode(newValue), forKey: "storedJoinOperationStreams")
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
                                               operators: [.delay(seconds: 1)]) }
        let serialStreamA = StreamModel(id: UUID(), name: "Serial Stream A",
                                        description: nil, stream: streamA, isDefault: true)

        let streamB = ["A", "B", "C", "D"].map {
            StreamItem(value: $0, operators: [.delay(seconds: 2)]) }
        let serialStreamB = StreamModel(id: UUID(), name: "Serial Stream B",
                                        description: nil, stream: streamB, isDefault: true)

        var newStreams = streams
        newStreams.append(serialStreamA)
        newStreams.append(serialStreamB)
        self.storedStreams = newStreams
        return newStreams
    }

    func appendDefaultTransformingOperationStreamsIfNeeded(streams: [TransformingOperationStreamModel<Int>])
        -> [TransformingOperationStreamModel<Int>] {
        guard streams.count == 0 else {
            return streams
        }
        let mapStreamModel = TransformingOperationStreamModel<Int>(id: UUID(),
                                                                   name: "Map Stream", description: "map { $0 * 2 }",
                                                                   operators: [.map(expression: "%d * 2")])

        let scanStreamModel = TransformingOperationStreamModel<Int>(id: UUID(), name: "Scan Stream",
                                                   description: "scan(0) { $0 + $1 }",
                                                   operators: [.scan(initialValue: 0, expression: "%d + %d")])

        let mixedStreamModel = TransformingOperationStreamModel<Int>(id: UUID(), name: "Map then Scan",
                                                      description: "map { $0 * 2 }.scan(0) { $0 + $1 }",
                                                      operators: [.map(expression: "%d * 2"),
                                                                  .scan(initialValue: 0, expression: "%d + %d")])
        return [mapStreamModel, scanStreamModel, mixedStreamModel]
    }

    func appendDefaultOperationStreamsIfNeeded(streams: [OperationStreamModel]) -> [OperationStreamModel] {
        guard streams.count == 0 else {
            return streams
        }

        let filterStreamModel = OperationStreamModel(id: UUID(),
                                                     name: "Filter Stream", description: "filter { $0 != 3 )",
                                                     operators: [.filtering(.filter(expression: "%d != 3"))])

        let dropStreamModel = OperationStreamModel(id: UUID(), name: "Drop Stream", description: "dropFirst(2)",
                                                   operators: [.filtering(.dropFirst(count: 2))])

        return [filterStreamModel, dropStreamModel]
    }

    func appendDefaultUnifyingOperationStreamsIfNeeded(streams: [UnifyingOperationStreamModel])
        -> [UnifyingOperationStreamModel] {
        let mergeStreamModel = UnifyingOperationStreamModel(id: UUID(), name: "Merge Stream",
                                                         description: "Publishers.merge(A, B)",
                                                         operatorItem: .merge)
        let flatMapStreamModel = UnifyingOperationStreamModel(id: UUID(),
                                                           name: "FlatMap Stream",
                                                           description: "A.flatMap { _ in B }",
                                                           operatorItem: .flatMap)
        let appendStreamModel = UnifyingOperationStreamModel(id: UUID(), name: "Append Stream",
                                                          description: "A.append(B)",
                                                          operatorItem: .append)
        return [mergeStreamModel, flatMapStreamModel, appendStreamModel]
    }

    func appendDefaultJoinOperationStreamsIfNeeded(streams: [JoinOperationStreamModel])
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
        storedTransformingOperationStreams = appendDefaultTransformingOperationStreamsIfNeeded(streams: [])
        storedUnifyingOperationStreams = appendDefaultUnifyingOperationStreamsIfNeeded(streams: [])
        storedJoinOperationStreams = appendDefaultJoinOperationStreamsIfNeeded(streams: [])
    }
}
