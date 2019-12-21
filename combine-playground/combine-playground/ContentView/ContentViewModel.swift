//
//  ContentViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/30/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {

    private var disposables = Set<AnyCancellable>()

    var cancellable: Cancellable?

    init() {
        refresh()
    }

    func refresh() {
    }

}
