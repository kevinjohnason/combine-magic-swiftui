//
//  NewStreamView.swift
//  combine-playground
//
//  Created by kevin.cheng on 12/26/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI

struct NewStreamView: View {

    @ObservedObject var viewModel: NewStreamViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Picker(selection: self.$viewModel.selectedTitle, label: Text("Select a Type").font(.footnote)) {
                ForEach(self.viewModel.streamTitles, id: \.self) { streamType in
                    Text(streamType)
                }
            }.padding()

            if viewModel.selectedTitle == viewModel.streamTitles[1] {
                UpdateOperationStreamView(viewModel: viewModel.newOperationStreamViewModel)
            } else if viewModel.selectedTitle == viewModel.streamTitles[2] {
                UpdateUnifyingStreamView(viewModel: viewModel.newUnifyingStreamViewModel)
            } else if viewModel.selectedTitle == viewModel.streamTitles[3] {
                UpdateJoinStreamView(viewModel: viewModel.newJoinStreamViewModel)
            } else {
                UpdateStreamView(viewModel: viewModel.newStreamViewModel)
            }
        }
    }
}

//struct NewStreamView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNewStreamView()
//    }
//}
