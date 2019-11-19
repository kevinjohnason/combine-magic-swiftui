//
//  CombineDoubleStreamView.swift
//  CombineTutorial
//
//  Created by Kevin Cheng on 10/27/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct DoublePublisherStreamView: View {
    @State private var stream1Values: [[String]] = []
    
    @State private var stream2Values: [[String]] = []
    
    @State private var streamResultValues: [[String]] = []
    
    @State private var disposables = Set<AnyCancellable>()
    
    var navigationBarTitle: String?
    
    var description: String?
    
    var comparingPublisher: (AnyPublisher<String, Never>, AnyPublisher<String, Never>) -> (AnyPublisher<(String, String), Never>)
    
    var body: some View {
        ScrollView {
        VStack(spacing: 30) {
            Spacer()
            DescriptiveTunnelView(streamValues: $stream1Values, description: "[1, 2, 3, 4]")
            DescriptiveTunnelView(streamValues: $stream2Values, description: "[A, B, C, D]")
            DescriptiveTunnelView(streamValues: $streamResultValues, description: description ?? "")
            HStack {
                Button("Subscribe") {
                    self.disposables.forEach {
                        $0.cancel()
                    }
                    self.disposables.removeAll()
                    let publisher = self.invervalValuePublisher(array: ["1", "2", "3", "4"])
                    publisher.sink {
                        self.stream1Values.append([$0])
                    }.store(in: &self.disposables)
                    
                    let publisher2 = self.invervalValuePublisher(array: ["A", "B", "C", "D"], interval: 1.5)
                    publisher2.sink {
                        self.stream2Values.append([$0])
                    }.store(in: &self.disposables)
                    
                    let comparingPublisher = self.comparingPublisher(publisher, publisher2)
                    comparingPublisher.sink {
                        self.streamResultValues.append([$0.0, $0.1])
                    }.store(in: &self.disposables)
                }.modifier(ButtonModifier(backgroundColor: Color.blue))
                if self.disposables.count > 0 {
                    Button("Cancel") {
                        self.disposables.removeAll()
                    }.modifier(ButtonModifier(backgroundColor: Color.red))
                } else {
                    Button("Clear") {
                        self.stream1Values.removeAll()
                        self.stream2Values.removeAll()
                        self.streamResultValues.removeAll()
                    }.modifier(ButtonModifier(backgroundColor: Color.red))
                }
            }
            Spacer()
            }
        }.navigationBarTitle(navigationBarTitle ?? "")
    }
    
    func invervalValuePublisher(array: [String], interval: Double = 1) -> AnyPublisher<String, Never> {
        let publishers = array
            .map { Just($0).delay(for: .seconds(interval), scheduler: DispatchQueue.main).eraseToAnyPublisher() }
        return publishers[1...].reduce(publishers[0]) {
            Publishers.Concatenate(prefix: $0, suffix: $1).eraseToAnyPublisher()
        }
    }
}

struct DoublePublisherStreamView_Previews: PreviewProvider {
    static var previews: some View {                
        DoublePublisherStreamView {
            Publishers.Zip($0, $1).eraseToAnyPublisher()
        }
    }
}
