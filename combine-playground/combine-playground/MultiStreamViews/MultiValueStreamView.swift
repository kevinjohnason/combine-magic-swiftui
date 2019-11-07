//
//  CombineStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/7/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct MultiValueStreamView: View {
    
    @ObservedObject var viewModel: StreamViewModel<[String]>
    
    var displayActionButtons: Bool = true
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Text(viewModel.title)
            .font(.system(.headline, design: .monospaced))
            .lineLimit(nil).padding()
            
            MultiBallTunnelView(values: $viewModel.values, color: .green, animationSecond: viewModel.animationSeconds)
            
            if displayActionButtons {
                HStack {
                    CombineDemoButton(text: "Subscribe", backgroundColor: .blue) {
                      self.viewModel.subscribe()
                    }
                    
                    CombineDemoButton(text: "Cancel", backgroundColor: .red) {
                      self.viewModel.cancel()
                    }
                }.padding()
            }
                        
            Spacer()
        }
    }
}

#if DEBUG
struct CombineSingleStreamView_Previews: PreviewProvider {
    static var previews: some View {
        MultiValueStreamView(viewModel: StreamViewModel<[String]>(title: "", publisher: Empty().eraseToAnyPublisher()))
    }
}
#endif
