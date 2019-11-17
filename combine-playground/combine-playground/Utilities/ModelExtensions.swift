//
//  CombineService.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import Combine

extension StreamModel {
    
    func toArrayStreamModel() -> StreamModel<[T]> {
        StreamModel<[T]>.init(id: self.id, name: self.name, description: self.description,
                              stream: self.stream.map { StreamItem(value: [$0.value], operatorItem: $0.operatorItem) },
                              isDefault: self.isDefault)
    }
    
}

extension StreamModel where T == String {
    
    var sequenceDescription: String {
        var desc = self.stream.reduce("Sequence(") {
            "\($0)\($1.value), "
        }
        guard let finalDotIndex = desc.lastIndex(of: ",") else {
            return "Empty()"
        }
        desc.removeSubrange(finalDotIndex..<desc.endIndex)
        desc.append(")")
        return desc
    }
    
    func toPublisher()  -> AnyPublisher<String, Never> {
        let intervalPublishers =
            self.stream.map { $0.toPublisher() }
        
        var publisher: AnyPublisher<String, Never>?
        
        for intervalPublisher in intervalPublishers {
            if publisher == nil {
                publisher = intervalPublisher
                continue
            }
            publisher = publisher?.append(intervalPublisher).eraseToAnyPublisher()
        }
        
        return publisher ?? Empty().eraseToAnyPublisher()
    }
    
}

extension StreamItem where T == String {
    func toPublisher()  -> AnyPublisher<String, Never> {
        var publisher: AnyPublisher<String, Never> = Just(value).eraseToAnyPublisher()
        var currentOperator = self.operatorItem
        while currentOperator != nil {
            guard let loopOperator = currentOperator else {
                break
            }
            publisher = loopOperator.applyPublisher(publisher)
            currentOperator = loopOperator.next
        }
        return publisher
    }
}

extension GroupOperationType {
    func applyPublishers(_ publishers: [AnyPublisher<String, Never>]) -> AnyPublisher<String, Never> {
        switch self {
        case .merge:
            return Publishers.MergeMany(publishers).eraseToAnyPublisher()
        case .flatMap:
            let initialPublisher: AnyPublisher<String, Never> = Just("").eraseToAnyPublisher()
            return publishers.reduce(initialPublisher) { (initial, next) -> AnyPublisher<String, Never> in
                initial.flatMap { _ in
                     next
                }.eraseToAnyPublisher()
            }
        case .append:
            guard let initialPublisher = publishers.first else {
                return Empty().eraseToAnyPublisher()
            }
            return publishers[1...].reduce(initialPublisher) {
                $0.append($1).eraseToAnyPublisher()
            }
        }
    }
}

extension CombineGroupOperationType {
    func applyPublishers(_ publishers: [AnyPublisher<String, Never>]) -> AnyPublisher<[String], Never> {
        guard publishers.count > 1 else {
            return Empty().eraseToAnyPublisher()
        }
        switch self {
        case .zip:
            return Publishers.Zip(publishers[0], publishers[1]).map {
                [$0, $1]
            }.eraseToAnyPublisher()
        case .combineLatest:
            return Publishers.CombineLatest(publishers[0], publishers[1]).map {
                [$0, $1]
            }.eraseToAnyPublisher()
        }
    }
}

extension Operator {
    var description: String {
        switch self {
        case .delay(let seconds, _):
            return ".delay(for: .seconds(\(seconds)), scheduler: DispatchQueue.main)"
        case .filter(let expression, _):
            return ".filter { \(expression) }"
        case .dropFirst(let count, _):
            return ".dropFirst(\(count))"
        case .map(let expression, _):
            return ".map { \(expression) }"
        case .scan(let expression, _):
            return ".scan(0) { \(expression) }"
        }
    }
    
    func applyPublisher(_ publisher: AnyPublisher<String, Never>) -> AnyPublisher<String, Never> {
        switch self {
        case .delay(let seconds, _):
            return publisher.delay(for: .seconds(seconds), scheduler: DispatchQueue.main).eraseToAnyPublisher()
        case .filter(let expression, _):
            return publisher.filter {
                NSPredicate(format: expression,
                            argumentArray: [Int($0) ?? 0])
                .evaluate(with: nil) }.eraseToAnyPublisher()
        case .dropFirst(let count, _):
            return publisher.dropFirst(count).eraseToAnyPublisher()
        case .map(let expression, _):
            return publisher.map { NSExpression(format: expression,
                                                argumentArray: [Int($0) ?? 0])
                .expressionValue(with: nil, context: nil) as? Int }
                .map { String($0 ?? 0) }.eraseToAnyPublisher()
        case .scan(let expression, _):
            return publisher.scan(0) { NSExpression(format: expression,
                                                    argumentArray: [$0, Int($1) ?? 0])
                                        .expressionValue(with: nil, context: nil) as? Int ?? 0 }
                .map { String($0) }.eraseToAnyPublisher()
        }
    }
    
    var next: Operator? {
        switch self {
        case .delay(_, let next):
            return next
        case .filter(_, let next):
            return next
        case .dropFirst(_, let next):
            return next
        case .map(_, let next):
            return next
        case .scan(_, let next):
            return next
        }
    }
}
