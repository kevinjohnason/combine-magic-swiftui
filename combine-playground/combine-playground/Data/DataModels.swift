//
//  DataModels.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/30/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import Combine
// swiftlint:disable identifier_name
struct StreamModel<T: Codable>: Codable, Identifiable, Updatable {
    var id: UUID
    var name: String?
    var description: String?
    var stream: [StreamItem<T>]
    var isDefault: Bool

    init(id: UUID = UUID(), name: String? = nil, description: String? = nil,
         stream: [StreamItem<T>] = [], isDefault: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.stream = stream
        self.isDefault = isDefault
    }
    static func new<T>() -> StreamModel<T> {
        StreamModel<T>()
    }
}

struct StreamItem<T: Codable>: Codable {
    let value: T
    var operators: [Operator]
}

protocol Updatable {
    var id: UUID { get set }
    var name: String? { get set }
    var description: String? { get set }
}

struct OperationStreamModel: Codable, Identifiable, Updatable {
    var id: UUID
    var name: String?
    var description: String?
    var operators: [Operator]
}

struct UnifyingOperationStreamModel: Codable, Identifiable, Updatable {
    var id: UUID
    var name: String?
    var description: String?
    var operatorItem: UnifyOparator
}

enum UnifyOparator: Codable {
    case merge(next: Operator?)
    case flatMap(next: Operator?)
    case append(next: Operator?)

    enum CodingKeys: CodingKey {
        case merge
        case flatMap
        case append
    }

    enum CodingError: Error { case decoding(String) }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let mergeNext = try container.decodeIfPresent((Operator?).self, forKey: .merge) {
            self = .merge(next: mergeNext)
        } else if let flatMapNext = try container.decodeIfPresent((Operator?).self, forKey: .flatMap) {
            self = .flatMap(next: flatMapNext)
        } else if let appendMapNext = try container.decodeIfPresent((Operator?).self, forKey: .append) {
            self = .append(next: appendMapNext)
        } else {
            throw CodingError.decoding("Decoding Failed. \(dump(container))")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .merge(let next):
            try container.encode(next, forKey: .merge)
        case .flatMap(let next):
            try container.encode(next, forKey: .flatMap)
        case .append(let next):
            try container.encode(next, forKey: .append)
        }
    }
}

enum Operator: Codable {

    private struct DelayParameters: Codable {
        let seconds: Double
    }
    case delay(seconds: Double)

    private struct ExpressionParameters: Codable {
           let expression: String
    }
    case filter(expression: String)

    private struct DropFirstParameters: Codable {
        let count: Int
    }
    case dropFirst(count: Int)

    case map(expression: String)

    case scan(expression: String)

    enum CodingKeys: CodingKey {
        case delay
        case filter
        case dropFirst
        case map
        case scan
    }

    enum CodingError: Error { case decoding(String) }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let delayParameters = try? container.decodeIfPresent(DelayParameters.self, forKey: .delay) {
            self = .delay(seconds: delayParameters.seconds)
          return
        } else if let filterParameters = try? container.decodeIfPresent(ExpressionParameters.self, forKey: .filter) {
            self = .filter(expression: filterParameters.expression)
          return
        } else if let dropFirstParameters =
            try? container.decodeIfPresent(DropFirstParameters.self, forKey: .dropFirst) {
            self = .dropFirst(count: dropFirstParameters.count)
          return
        } else if let mapParameters = try? container.decodeIfPresent(ExpressionParameters.self, forKey: .map) {
            self = .map(expression: mapParameters.expression)
        } else if let scanParameters = try? container.decodeIfPresent(ExpressionParameters.self, forKey: .scan) {
            self = .scan(expression: scanParameters.expression)
        } else {
            throw CodingError.decoding("Decoding Failed. \(dump(container))")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .delay(let seconds):
            try container.encode(DelayParameters(seconds: seconds), forKey: .delay)
        case .filter(let expression):
            try container.encode(ExpressionParameters(expression: expression), forKey: .filter)
        case .dropFirst(let count):
            try container.encode(DropFirstParameters(count: count), forKey: .dropFirst)
        case .map(let expression):
            try container.encode(ExpressionParameters(expression: expression), forKey: .map)
        case .scan(let expression):
            try container.encode(ExpressionParameters(expression: expression), forKey: .scan)
        }
    }

}

struct JoinOperationStreamModel: Codable, Identifiable, Updatable {
    var id: UUID
    var name: String?
    var description: String?
    var operatorItem: JoinOperator
}

enum JoinOperator: String, Codable {
    case zip
    case combineLatest
}
