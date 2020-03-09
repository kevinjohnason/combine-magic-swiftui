//
//  UserDefaultsWrapper.swift
//  combine-playground
//
//  Created by Kevin Cheng on 3/8/20.
//  Copyright © 2020 Kevin-Cheng. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}
