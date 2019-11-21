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

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var viewModel: UpdateOperationStreamViewModel

    var body: some View {
        List {
                VStack {
                    TextField("Operation Name", text: $viewModel.title)
                    TextField("Description", text: $viewModel.description)
                    Picker(selection: self.$viewModel.selectedOperator, label: Text("Select a Type")) {
                        ForEach(self.viewModel.operators, id: \.self) { operatorItem in
                            Text(operatorItem).tag(operatorItem)
                        }
                    }
                    TextField(self.viewModel.parameterTitle, text: self.$viewModel.parameter)
                    Spacer()
                }
            Button("Save") {
                self.viewModel.save()
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

//struct UpdateOperationStreamView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateOperationStreamView(viewModel: UpdateOperationStreamViewModel())
//    }
//}
