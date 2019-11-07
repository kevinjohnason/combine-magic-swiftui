//
//  MultiBallViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 9/12/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import SwiftUI
class MultiBallViewModel: ObservableObject, Identifiable {
    @Published var values: [String]
    let id: Date = Date()
    @Published var isHidden: Bool = false
    @Published var offset: CGSize = .zero
    init(values: [String]) {
        self.values = values
    }
}
