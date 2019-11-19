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
