//
//  OperatorExtensions.swift
//  combine-playground
//
//  Created by Kevin Cheng on 11/19/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import Foundation
import Combine

extension UnifyOparator {
    func applyPublishers(_ publishers: [AnyPublisher<String, Never>]) -> AnyPublisher<String, Never> {
        let appliedPublisher: AnyPublisher<String, Never>
        var nextOperator: Operator?
        switch self {
        case .merge(let next):
            nextOperator = next
            appliedPublisher = Publishers.MergeMany(publishers).eraseToAnyPublisher()
        case .flatMap(let next):
            nextOperator = next
            let initialPublisher: AnyPublisher<String, Never> = Just("").eraseToAnyPublisher()
            appliedPublisher = publishers.reduce(initialPublisher) { (initial, next) -> AnyPublisher<String, Never> in
                initial.flatMap { _ in
                     next
                }.eraseToAnyPublisher()
            }
        case .append(let next):
            nextOperator = next
            if let initialPublisher = publishers.first {
                appliedPublisher = publishers[1...].reduce(initialPublisher) {
                    $0.append($1).eraseToAnyPublisher()
                }
            } else {
                appliedPublisher = Empty().eraseToAnyPublisher()
            }
        }
        if let nextOperator = nextOperator {
            return nextOperator.applyPublisher(appliedPublisher)
        }
        return appliedPublisher
    }
}

extension JoinOperator {
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
