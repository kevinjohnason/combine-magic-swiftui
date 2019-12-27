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

public typealias DisposeSet = Set<AnyCancellable>
