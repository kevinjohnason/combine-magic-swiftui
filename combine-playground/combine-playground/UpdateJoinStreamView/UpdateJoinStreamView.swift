//
//  UpdateJoinStreamView.swift
//  combine-playground
//
//  Created by kevin.cheng on 11/20/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct UpdateJoinStreamView: View {

    var body: some View {
        VStack {
            MultiValueStreamView(viewModel: StreamViewModel(title: "Source Stream",
                                                            publisher: Empty().eraseToAnyPublisher()),
                                 displayActionButtons: false)
        }
    }
}

struct UpdateJoinStreamView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateJoinStreamView()
    }
}
