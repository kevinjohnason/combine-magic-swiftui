//
//  CombineZipStreamView.swift
//  CombineTutorial
//
//  Created by Kevin Cheng on 10/30/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
import Combine

struct CombineZipStreamView: View {
    @State private var stream1Values: [[String]] = []
    
    @State private var stream2Values: [[String]] = []
    
    @State private var streamResultValues: [[String]] = []        
    
    @State private var disposables = Set<AnyCancellable>()
    
    var navigationBarTitle: String?
    
    var description: String?
    
    var comparingPublisher: (AnyPublisher<String, Never>, AnyPublisher<String, Never>) -> (AnyPublisher<(String, String), Never>)
    
    var body: some View {
                VStack(spacing: 30) {
            Spacer()
            Text(description ?? "")
                .font(.system(.headline, design: .monospaced))
                .lineLimit(nil).padding()
            TunnelView(streamValues: $stream1Values)
            TunnelView(streamValues: $stream2Values)
            TunnelView(streamValues: $streamResultValues)
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
                    
                    let publisher2 = self.invervalValuePublisher(array: ["A", "B", "C", "D"])
                    publisher2.sink {
                        self.stream2Values.append([$0])
                    }.store(in: &self.disposables)
                    
                    let comparingPublisher = self.comparingPublisher(publisher, publisher2)
                    comparingPublisher.sink {
                        self.streamResultValues.append([$0.0, $0.1])
                    }.store(in: &self.disposables)
                }
                if self.disposables.count > 0 {
                    Button("Cancel") {
                        self.disposables.removeAll()
                    }
                } else {
                    Button("Clear") {
                        self.stream1Values.removeAll()
                        self.stream2Values.removeAll()
                        self.streamResultValues.removeAll()
                    }
                }
            }
            Spacer()
        }.navigationBarTitle(navigationBarTitle ?? "")
    }
    
    func invervalValuePublisher(array: [String]) -> AnyPublisher<String, Never> {
        let publishers = array
            .map { Just($0).delay(for: .seconds(1), scheduler: DispatchQueue.main).eraseToAnyPublisher() }
        return publishers[1...].reduce(publishers[0]) {
            Publishers.Concatenate(prefix: $0, suffix: $1).eraseToAnyPublisher()
        }
    }
}

struct CombineZipStreamView_Previews: PreviewProvider {
    static var previews: some View {
        CombineZipStreamView {
            Publishers.Zip($0, $1).eraseToAnyPublisher()
        }
    }
}
