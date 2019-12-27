//
//  UnwrapPublisher.swift
//  CombineExtensions
//
//  Created by Kevin Cheng on 12/27/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import Combine

public extension Publishers {
    
    struct Unwrap<Upstream, Output> : Publisher where Upstream : Publisher, Upstream.Output == Optional<Output> {

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
}

extension Publishers.Unwrap {
    private class UnwrapSubscriber<Upstream: Publisher, DownStream: Subscriber>: Subscriber
    where Upstream.Failure == DownStream.Failure, Upstream.Output == Optional<DownStream.Input> {

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

public extension Publisher {
    func unwrap<T>() -> Publishers.Unwrap<Self, T> where Self.Output == Optional<T> {
        Publishers.Unwrap(upstream: self)
    }
}
