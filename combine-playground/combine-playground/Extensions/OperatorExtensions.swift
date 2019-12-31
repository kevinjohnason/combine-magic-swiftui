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
        switch self {
        case .merge:
            appliedPublisher = Publishers.MergeMany(publishers).eraseToAnyPublisher()
        case .flatMap:
            let initialPublisher: AnyPublisher<String, Never> = Just("").eraseToAnyPublisher()
            appliedPublisher = publishers.reduce(initialPublisher) { (initial, next) -> AnyPublisher<String, Never> in
                initial.flatMap { _ in
                    next
                }.eraseToAnyPublisher()
            }
        case .append:
            if let initialPublisher = publishers.first {
                appliedPublisher = publishers[1...].reduce(initialPublisher) {
                    $0.append($1).eraseToAnyPublisher()
                }
            } else {
                appliedPublisher = Empty().eraseToAnyPublisher()
            }
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
        case .delay(let seconds):
            return ".delay(for: .seconds(\(seconds)), scheduler: DispatchQueue.main)"
        case .filter(let expression):
            return ".filter { \(expression) }"
        case .dropFirst(let count):
            return ".dropFirst(\(count))"
        case .map(let expression):
            return ".map { \(expression) }"
        case .scan(let expression):
            return ".scan(0) { \(expression) }"
        }
    }

    func applyPublisher(_ publisher: AnyPublisher<String, Never>) -> AnyPublisher<String, Never> {
        switch self {
        case .delay(let seconds):
            return publisher.delay(for: .seconds(seconds), scheduler: DispatchQueue.main).eraseToAnyPublisher()
        case .filter(let expression):
            return publisher.filter {
                NSPredicate(format: expression,
                            argumentArray: [Int($0) ?? 0])
                    .evaluate(with: nil) }.eraseToAnyPublisher()
        case .dropFirst(let count):
            return publisher.dropFirst(count).eraseToAnyPublisher()
        case .map(let expression):
            return publisher.map { NSExpression(format: expression,
                                                argumentArray: [Int($0) ?? 0])
                .expressionValue(with: nil, context: nil) as? Int }
                .map { String($0 ?? 0) }.eraseToAnyPublisher()
        case .scan(let expression):
            return publisher.scan(0) { NSExpression(format: expression,
                                                    argumentArray: [$0, Int($1) ?? 0])
                .expressionValue(with: nil, context: nil) as? Int ?? 0 }
                .map { String($0) }.eraseToAnyPublisher()
        }
    }

    func applyPublisher<T>(_ publisher: AnyPublisher<T, Never>) -> AnyPublisher<T, Never> {
        switch self {
        case .delay(let seconds):
            return publisher.delay(for: .seconds(seconds), scheduler: DispatchQueue.main).eraseToAnyPublisher()
        case .dropFirst(let count):
            return publisher.dropFirst(count).eraseToAnyPublisher()
        default:
            return publisher
        }
    }

    func applyTransformPublisher<T, U>(_ publisher: AnyPublisher<T, Never>) -> AnyPublisher<U, Never> {
        switch self {
        case .map(let expression):
            return publisher.map { NSExpression(format: expression,
                                            argumentArray: [$0])
            .expressionValue(with: nil, context: nil) as? U }
            .unwrap()
            .eraseToAnyPublisher()
        default:
            return Empty().eraseToAnyPublisher()
        }
    }
}
