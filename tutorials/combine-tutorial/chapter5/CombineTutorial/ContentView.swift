//
//  ContentView.swift
//  CombineTutorial
//
//  Created by kevin.cheng on 9/24/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: DoublePublisherStreamView(navigationBarTitle: "Zip", description: "Publishers.Zip(publisher1, publisher2)", comparingPublisher: self.zipPublisher)) {
                    Text("Zip")
                }
                NavigationLink(destination: DoublePublisherStreamView(navigationBarTitle: "CombineLatest", description: "Publishers.CombineLatest(publisher1, publisher2)", comparingPublisher: self.combineLatestPublisher)) {
                    Text("CombineLatest")
                }
            }.navigationBarTitle("Combine Operators")
        }
    }
    
    func zipPublisher(_ publisher1: AnyPublisher<String, Never>,
                        _ publisher2: AnyPublisher<String, Never>) -> AnyPublisher<(String, String), Never>{
        Publishers.Zip(publisher1, publisher2).eraseToAnyPublisher()
    }
    
    func combineLatestPublisher(_ publisher1: AnyPublisher<String, Never>,
    _ publisher2: AnyPublisher<String, Never>) -> AnyPublisher<(String, String), Never> {
        Publishers.CombineLatest(publisher1, publisher2).eraseToAnyPublisher()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
