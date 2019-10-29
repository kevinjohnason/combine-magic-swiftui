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
                NavigationLink(destination: DoublePublisherStreamView(navigationBarTitle: "Merge", description: "Publishers.Merge(publisher1, publisher2)", comparingPublisher: self.mergePublisher)) {
                    Text("Merge")
                }
                NavigationLink(destination: DoublePublisherStreamView(navigationBarTitle: "Append", description: "publisher1.append(publisher2)", comparingPublisher: appendPublisher)) {
                    Text("Append")
                }
            }.navigationBarTitle("Combine Operators")
        }
    }
    
    func mergePublisher(_ publisher1: AnyPublisher<String, Never>,
                        _ publisher2: AnyPublisher<String, Never>) -> AnyPublisher<String, Never>{
        Publishers.Merge(publisher1, publisher2).eraseToAnyPublisher()
    }
    
    func appendPublisher(_ publisher1: AnyPublisher<String, Never>,
                         _ publisher2: AnyPublisher<String, Never>) -> AnyPublisher<String, Never> {
        publisher1.append(publisher2).eraseToAnyPublisher()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
