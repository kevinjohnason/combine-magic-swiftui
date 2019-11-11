//
//  CombineStreamView.swift
//  CombineTutorial
//
//  Created by kevin.cheng on 10/5/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
import Combine

struct CombineStreamView: View {
    
    @State var streamValues: [[String]] = []
    
    @State var cancellable: AnyCancellable?
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            TunnelView(streamValues: $streamValues)
            HStack {
                Button("Subscribe") {
                    self.cancellable?.cancel()
                    self.cancellable = self.invervalValuePublisher()
                        .sink(receiveCompletion: { _ in
                            self.cancellable = nil
                        }, receiveValue: {
                            self.streamValues.append([$0])
                        })
                }.modifier(ButtonModifier(backgroundColor: Color.blue))
                if self.cancellable != nil {
                    Button("Cancel") {
                        self.cancellable = nil
                    }.modifier(ButtonModifier(backgroundColor: Color.red))
                } else {
                    Button("Clear") {
                        self.streamValues.removeAll()
                    }.modifier(ButtonModifier(backgroundColor: Color.red))
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

struct CombineStreamView_Previews: PreviewProvider {
    static var previews: some View {
        CombineStreamView().previewLayout(.sizeThatFits)
    }
}
