//
//  CombineScanStreamView.swift
//  CombineTutorial
//
//  Created by Kevin Cheng on 10/22/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
import Combine

struct CombineScanStreamView: View {
    @State private var stream1Values: [[String]] = []
    
    @State private var stream2Values: [[String]] = []
    
    @State private var disposables = Set<AnyCancellable>()
            
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            TunnelView(streamValues: $stream1Values)
            TunnelView(streamValues: $stream2Values)
            HStack {
                Button("Subscribe") {
                    self.disposables.cancelAll()
                    let publisher = self.invervalValuePublisher()
                    publisher.sink {
                        self.stream1Values.append([$0])
                    }.store(in: &self.disposables)
                    let scanPublisher = publisher.map { Int($0) ?? 0 }.scan(0) { $0 + $1 }.map { String($0) }
                    scanPublisher.sink {
                        self.stream2Values.append([$0])
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
                    }
                }
            }
            Spacer()
        }
    }
    
    func invervalValuePublisher() -> AnyPublisher<String, Never> {
        let publishers = (1...5).map { String($0) }
            .map { Just($0).delay(for: .seconds(1), scheduler: DispatchQueue.main).eraseToAnyPublisher() }
        return publishers[1...].reduce(publishers[0]) {
            Publishers.Concatenate(prefix: $0, suffix: $1).eraseToAnyPublisher()
        }
    }
}

struct CombineScanStreamView_Previews: PreviewProvider {
    static var previews: some View {
        CombineScanStreamView()
    }
}
