//
//  ContentView.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct ContentView: View {
    @EnvironmentObject var streamStore: StreamStore

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Stream data")) {
                        StreamListView()
                    }
                    Section(header: Text("Basic Operators")) {
                        OperationStreamListView()
                    }
                    Section(header: Text("Unifying Operators")) {
                        UnifyingOperationListStreamView()
                    }
                    Section(header: Text("Join Operators")) {
                        JoinOperationListStreamView()
                    }
                }
                Button("Reset") {
                    DataService.shared.resetStoredStream()
                }.frame(maxWidth: .infinity, maxHeight: 25)
                .modifier(DemoButton(backgroundColor: .red))
            }.navigationBarTitle("Streams")
            .navigationBarItems(leading: EditButton(), trailing: createStreamView)
        }
    }
    var createStreamView: some View {
        NavigationLink(destination: UpdateStreamView(
            viewModel: UpdateStreamViewModel(streamModel: StreamModel<String>.new()))) {
            Image(systemName: "plus.circle").font(Font.system(size: 30))
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()//.previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
#endif
