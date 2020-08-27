//
//  SingleStreamViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/1/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class StreamViewModel<T>: ObservableObject {

    var title: String {
        didSet {
            updatableTitle = title
        }
    }
    // Simply to work around XCode bug that doesn't comipled a publishable title
    @Published var updatableTitle: String
    var description: String {
        didSet {
            updatableDescription = description
        }
    }
    // Simply to work around XCode bug that doesn't comipled a publishable description
    @Published var updatableDescription: String
    var publisher: AnyPublisher<T, Never>
    @Published var values: [IdentifiableValue<T>] = []
    let animationSeconds: Double = 1.5
    var cancellable: Cancellable?
    var editable: Bool

    init(title: String, description: String = "", publisher: AnyPublisher<T, Never>, editable: Bool = false) {
        self.title = title
        self.updatableTitle = title
        self.description = description
        self.updatableDescription = description
        self.publisher = publisher
        self.editable = editable
    }

    func subscribe() {
        cancellable?.cancel()
        cancellable = publisher.map { value in
            var newValues = self.values
            newValues.append(IdentifiableValue(value: value))
            return newValues
        }.assign(to: \.values, on: self)
    }

    func cancel() {
        self.cancellable?.cancel()
        self.values.removeAll()
    }

    deinit {
        cancellable?.cancel()
    }

    func toArrayViewModel() -> StreamViewModel<[T]> {
        StreamViewModel<[T]>(title: self.title, description: self.description,
                             publisher: self.publisher.map { [$0] }.eraseToAnyPublisher(), editable: self.editable)
    }

    func toStringArrayViewModel() -> StreamViewModel<[String]> {
        StreamViewModel<[String]>(title: self.title, description: self.description,
                             publisher: self.publisher.map { ["\($0)"] }.eraseToAnyPublisher(), editable: self.editable)
    }
}

struct IdentifiableValue<T>: Identifiable {
    var value: T
    // swiftlint:disable identifier_name
    var id: UUID

    init(value: T) {
        self.id = UUID()
        self.value = value
    }
}

extension StreamViewModel where T == [String] {
    func flatMapViewModel() -> StreamViewModel<String> {
        StreamViewModel<String>(title: self.title, description: self.description,
                                publisher: self.publisher.map { $0[0] }.eraseToAnyPublisher(), editable: self.editable)
    }
}
