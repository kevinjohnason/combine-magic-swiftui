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
        CombineScanStreamView()
//        NavigationView {
//            List {
//                NavigationLink(destination: GenericCombineStreamView(navigationBarTitle: "Map", description: ".map { $0 * 2 }", comparingPublisher: self.mapPublisher)) {
//                    Text("Map")
//                }
//                NavigationLink(destination: GenericCombineStreamView(navigationBarTitle: "Scan", description: ".scan(0) { $0 + $1 }", comparingPublisher: self.scanPublisher)) {
//                    Text("Scan")
//                }
//                NavigationLink(destination: GenericCombineStreamView(navigationBarTitle: "Filter", description: ".filter { $0 != 2 }", comparingPublisher: self.filterPublisher)) {
//                    Text("Filter")
//                }
//                NavigationLink(destination: GenericCombineStreamView(navigationBarTitle: "Drop", description: ".dropFirst(2)", comparingPublisher: self.dropPublisher)) {
//                    Text("Drop")
//                }
//            }.navigationBarTitle("Combine Operators")
//        }
    }
        
    func mapPublisher(publisher: AnyPublisher<String, Never>) -> AnyPublisher<String, Never> {
        publisher.map { (Int($0) ?? 0) * 2 }.map { String($0) }.eraseToAnyPublisher()
    }
    
    func scanPublisher(publisher: AnyPublisher<String, Never>) -> AnyPublisher<String, Never> {
        publisher.map { Int($0) ?? 0 }.scan(0) { $0 + $1 }.map { String($0) }.eraseToAnyPublisher()
    }
    
    func filterPublisher(publisher: AnyPublisher<String, Never>) -> AnyPublisher<String, Never> {
        publisher.filter { $0 != "2" }.eraseToAnyPublisher()
    }
    
    func dropPublisher(publisher: AnyPublisher<String, Never>) -> AnyPublisher<String, Never> {
        publisher.dropFirst(2).eraseToAnyPublisher()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
