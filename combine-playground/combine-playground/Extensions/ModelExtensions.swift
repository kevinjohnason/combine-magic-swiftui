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
                              stream: self.stream.map { StreamItem(value: [$0.value], operators: $0.operators) },
                              isDefault: self.isDefault)
    }
}

extension StreamModel where T == [String] {
    func flatMapModel() -> StreamModel<String> {
        StreamModel<String>(id: self.id, name: self.name, description: self.description,
                            stream: self.stream.map { StreamItem(value: $0.value[0],
                                                                 operators: $0.operators) },
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

extension StreamModel {

    func toPublisher() -> AnyPublisher<T, Never> {
        let intervalPublishers =
            self.stream.map { $0.toPublisher() }

        var publisher: AnyPublisher<T, Never>?

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
        self.operators.forEach {
            publisher = $0.applyPublisher(publisher)
        }
        return publisher
    }
}

extension StreamItem {
    func toPublisher() -> AnyPublisher<T, Never> {
        var publisher: AnyPublisher<T, Never> = Just(value).eraseToAnyPublisher()
        self.operators.forEach {
            publisher = $0.applyPublisher(publisher)
        }
        return publisher
    }
}
