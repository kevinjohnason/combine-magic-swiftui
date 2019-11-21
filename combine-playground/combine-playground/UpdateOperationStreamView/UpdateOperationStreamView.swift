//
//  UpdateOperationStreamView.swift
//  combine-playground
//
//  Created by kevin.cheng on 11/20/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
import Combine

struct UpdateOperationStreamView: View {

    @ObservedObject var viewModel: UpdateOperationStreamViewModel

    var body: some View {
        List {
            MultiValueStreamView(viewModel: StreamViewModel(title: "Source Stream",
                                                            publisher: Empty().eraseToAnyPublisher()),
                                 displayActionButtons: false)//.frame(maxHeight: 120)

                VStack {
                    Text(viewModel.operationStreamModel.name ?? "")
                    Picker(selection: self.$viewModel.selectedOperator, label: Text("Select a Type")) {
                        ForEach(self.viewModel.operators, id: \.self) { operatorItem in
                            Text(operatorItem).tag(operatorItem)
                        }
                    }
                    TextField(self.viewModel.parameterTitle, text: self.$viewModel.parameter)
                    Spacer()
                }
        }
    }
}

//struct UpdateOperationStreamView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateOperationStreamView(viewModel: UpdateOperationStreamViewModel())
//    }
//}
