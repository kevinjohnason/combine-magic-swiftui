//
//  PlaygroundStreamView.swift
//  combine-playground
//
//  Created by Kevin Cheng on 12/31/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI

struct PlaygroundStreamView: View {
    @EnvironmentObject var streamStore: StreamStore

    var viewModel: PlaygroundStreamViewModel {
        PlaygroundStreamViewModel(streamStore: streamStore)
    }

    var body: some View {
        VStack {
            MultiStreamView(viewModel: viewModel.multiStreamViewModel)
        }
    }
}

struct PlaygroundStreamView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundStreamView()
    }
}
