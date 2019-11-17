//
//  BallViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/27/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import SwiftUI

class CircularTextViewModel: ObservableObject, Identifiable {
    @Published var value: String
    let id: Date = Date()
    @Published var isHidden: Bool = false
    @Published var offset: CGSize = .zero
    init(value: String) {
        self.value = value
    }
}
