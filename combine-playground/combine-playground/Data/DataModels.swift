//
//  DataModels.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/30/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation

struct StreamModel<T: Codable>: Codable, Identifiable {
    var id: UUID
    var name: String?
    var description: String?
    var stream: [StreamItem<T>]
    var isDefault: Bool
    
    init(id: UUID = UUID(), name: String? = nil, description: String? = nil, stream: [StreamItem<T>] = [], isDefault: Bool = false) {
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
    var operatorItem: Operator?
}

enum OperatorType: String, Codable {
    case delay
    case filter
    case drop
    case map
    case scan
}


struct OperationStreamModel: Codable, Identifiable {
    var id: UUID
    var name: String?
    var description: String?
    var streamModelId: UUID
    var operatorItem: Operator
}

enum GroupOperationType: String, Codable {
    case merge
    case flatMap
    case append
}

enum CombineGroupOperationType: String, Codable {
    case zip
    case combineLatest
}

struct GroupOperationStreamModel: Codable, Identifiable {
    var id: UUID
    var name: String?
    var description: String?
    var streamModelIds: [UUID]
    var operationType: GroupOperationType
}

struct CombineGroupOperationStreamModel: Codable, Identifiable {
    var id: UUID
    var name: String?
    var description: String?
    var streamModelIds: [UUID]
    var operatorType: CombineGroupOperationType
}

indirect enum Operator: Codable {
    
    private struct DelayParameters: Codable {
        let seconds: Double
        let next: Operator?
    }
    case delay(seconds: Double, next: Operator?)
    
    private struct ExpressionParameters: Codable {
           let expression: String
           let next: Operator?
    }
    case filter(expression: String, next: Operator?)
    
    private struct DropFirstParameters: Codable {
        let count: Int
        let next: Operator?
    }
    case dropFirst(count: Int, next: Operator?)

    case map(expression: String, next: Operator?)
    
    case scan(expression: String, next: Operator?)
    
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
            self = .delay(seconds: delayParameters.seconds, next: delayParameters.next)
          return
        } else if let filterParameters = try? container.decodeIfPresent(ExpressionParameters.self, forKey: .filter) {
            self = .filter(expression: filterParameters.expression, next: filterParameters.next)
          return
        } else if let dropFirstParameters = try? container.decodeIfPresent(DropFirstParameters.self, forKey: .dropFirst) {
            self = .dropFirst(count: dropFirstParameters.count, next: dropFirstParameters.next)
          return
        } else if let mapParameters = try? container.decodeIfPresent(ExpressionParameters.self, forKey: .map) {
            self = .map(expression: mapParameters.expression, next: mapParameters.next)
        } else if let scanParameters = try? container.decodeIfPresent(ExpressionParameters.self, forKey: .scan) {
            self = .scan(expression: scanParameters.expression, next: scanParameters.next)
        }
        throw CodingError.decoding("Decoding Failed. \(dump(container))")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .delay(let seconds, let next):
            try container.encode(DelayParameters(seconds: seconds, next: next), forKey: .delay)
        case .filter(let expression, let next):
            try container.encode(ExpressionParameters(expression: expression, next: next), forKey: .delay)
        case .dropFirst(let count, let next):
            try container.encode(DropFirstParameters(count: count, next: next), forKey: .dropFirst)
        case .map(let expression, let next):
            try container.encode(ExpressionParameters(expression: expression, next: next), forKey: .map)
        case .scan(let expression, let next):
            try container.encode(ExpressionParameters(expression: expression, next: next), forKey: .scan)
        }
    }
    
}
