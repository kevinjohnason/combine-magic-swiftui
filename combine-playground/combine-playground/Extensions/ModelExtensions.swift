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

    func toIntModel() -> StreamModel<Int> {
        let streamItems = self.stream.map { StreamItem(value: Int($0.value) ?? 0, operators: $0.operators) }
        return StreamModel<Int>(id: id, name: name, description: description,
                                stream: streamItems, isDefault: isDefault)
    }
}

extension StreamModel {

    func toPublisher() -> AnyPublisher<T, Never> {
        let intervalPublishers =
            self.stream.map { $0.toPublisher() }

        guard intervalPublishers.count > 0 else {
            return Empty().eraseToAnyPublisher()
        }
        return intervalPublishers[1...].reduce(intervalPublishers[0]) {
            $0.append($1).eraseToAnyPublisher()
        }
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
