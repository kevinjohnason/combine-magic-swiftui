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

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: UpdateJoinStreamViewModel
    @EnvironmentObject var streamStore: StreamStore

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            TextField("Operation Name", text: $viewModel.title).font(.headline)
            TextField("Description", text: $viewModel.description).font(.subheadline)
            Picker(selection: self.$viewModel.selectedOperator, label: Text("Select a Type").font(.footnote)) {
                ForEach(self.viewModel.operators, id: \.self) { operatorItem in
                    Text(operatorItem).tag(operatorItem)
                }
            }.padding()
            Spacer()
            VStack(spacing: 10) {
                Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                }.foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.gray)
                Button("Save") {
                    self.viewModel.save()
                    self.streamStore.save(self.viewModel.operationModel)
                    self.presentationMode.wrappedValue.dismiss()
                }.foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
            }.padding(.top, 30)
        }.multilineTextAlignment(.center).padding(.top, 15)
    }
}

//struct UpdateJoinStreamView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateJoinStreamView()
//    }
//}
