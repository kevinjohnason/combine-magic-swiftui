//
//  CombineExtensions.swift
//  combine-extensions
//
//  Created by kevin.cheng on 11/20/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import Foundation
import Combine

public extension Set where Element == AnyCancellable {
    mutating func cancelAll() {
        self.forEach {
            $0.cancel()
        }
        self.removeAll()
    }
}

public typealias DisposeBag = Set<AnyCancellable>


extension Publishers {

    ///// A publisher that transforms all elements from the upstream publisher with a provided closure.
    public struct Unwrap<Upstream, Output> : Publisher where Upstream : Publisher, Upstream.Output == Optional<Output> {

        public typealias Failure = Upstream.Failure

        public let upstream: Upstream

        public init(upstream: Upstream) {
            self.upstream = upstream
        }


        public func receive<Downstream>(subscriber: Downstream) where Downstream : Subscriber,
            Failure == Downstream.Failure, Output == Downstream.Input {
                upstream.subscribe(UnwrapSubscriber(upstream: upstream, downstream: subscriber))
        }

    }

    private class UnwrapSubscriber<Upstream: Publisher, DownStream: Subscriber>: Subscriber
    where Upstream.Failure == DownStream.Failure, Upstream.Output == Optional<DownStream.Input> {
        typealias Failure = Upstream.Failure

        private let upstream: Upstream
        private let downstream: DownStream

        init(upstream: Upstream, downstream: DownStream) {
          self.upstream = upstream
          self.downstream = downstream
        }

        func receive(subscription: Subscription) {
            downstream.receive(subscription: subscription)
        }

        func receive(_ input: Upstream.Output) -> Subscribers.Demand {
            guard let input = input else {
                return .none
            }
            return downstream.receive(input)
        }

        func receive(completion: Subscribers.Completion<Upstream.Failure>) {
            downstream.receive(completion: completion)
        }
    }
}

extension Publisher where Output == Optional {
    func unwrap() -> Publishers.Unwrap<Self, > {
        Publishers.Unwrap(upstream: self)
    }
}
