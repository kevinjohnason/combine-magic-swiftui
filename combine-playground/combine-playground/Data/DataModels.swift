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
    var operators: [UtilityOperator]
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

struct TransformingOperationStreamModel<T: Codable>: Codable, Identifiable, Updatable {
    var id: UUID
    var name: String?
    var description: String?
    var operators: [TransformingOperator<T>]
}

struct UnifyingOperationStreamModel: Codable, Identifiable, Updatable {
    var id: UUID
    var name: String?
    var description: String?
    var operatorItem: UnifyOparator
}

enum UnifyOparator: String, Codable {
    case merge
    case flatMap
    case append
}

enum CodingError: Error { case decoding(String) }

enum UtilityOperator: Codable {
    private struct DelayParameters: Codable {
        let seconds: Double
    }
    case delay(seconds: Double)

    enum CodingKeys: CodingKey {
         case delay
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let delayParameters = try? container.decodeIfPresent(DelayParameters.self, forKey: .delay) {
            self = .delay(seconds: delayParameters.seconds)
          return
        }
        throw CodingError.decoding("Decoding Failed. \(dump(container))")
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .delay(let seconds):
            try container.encode(DelayParameters(seconds: seconds), forKey: .delay)
       }
    }
}

enum FilterOperator: Codable {
    private struct ExpressionParameters: Codable {
           let expression: String
    }
    case filter(expression: String)

    private struct DropFirstParameters: Codable {
        let count: Int
    }
    case dropFirst(count: Int)

    enum CodingKeys: CodingKey {
        case filter
        case dropFirst
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let filterParameters = try? container.decodeIfPresent(ExpressionParameters.self, forKey: .filter) {
            self = .filter(expression: filterParameters.expression)
          return
        } else if let dropFirstParameters =
            try? container.decodeIfPresent(DropFirstParameters.self, forKey: .dropFirst) {
            self = .dropFirst(count: dropFirstParameters.count)
          return
        } else {
            throw CodingError.decoding("Decoding Failed. \(dump(container))")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .filter(let expression):
            try container.encode(ExpressionParameters(expression: expression), forKey: .filter)
        case .dropFirst(let count):
            try container.encode(DropFirstParameters(count: count), forKey: .dropFirst)
        }
    }
}

enum TransformingOperator<Output: Codable>: Codable {
    case map(expression: String)
    case scan(initialValue: Output, expression: String)

    enum CodingKeys: CodingKey {
        case map
        case scan
    }

    private struct ExpressionParameters: Codable {
        let expression: String
    }

    private struct ScanParameters: Codable {
        let initialValue: Output
        let expression: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let mapParameters = try? container.decodeIfPresent(ExpressionParameters.self, forKey: .map) {
            self = .map(expression: mapParameters.expression)
        } else if let scanParameters = try? container.decodeIfPresent(ScanParameters.self, forKey: .scan) {
            self = .scan(initialValue:scanParameters.initialValue, expression: scanParameters.expression)
        } else {
            throw CodingError.decoding("Decoding Failed. \(dump(container))")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .map(let expression):
            try container.encode(ExpressionParameters(expression: expression), forKey: .map)
        case .scan(let initialValue, let expression):
            try container.encode(ScanParameters(initialValue: initialValue, expression: expression),
                                 forKey: .scan)
        }
    }
}

/// Basic Operator only modify publishers' behavior without casting types
enum Operator: Codable {

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
        case filter
        case dropFirst
        case map
        case scan
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let filterParameters = try? container.decodeIfPresent(ExpressionParameters.self, forKey: .filter) {
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
