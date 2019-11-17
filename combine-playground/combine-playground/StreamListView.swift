//
//  StreamListView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/30/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct StreamListView: View {
    
    @Binding var storedStreams: [StreamModel<String>]
    
    @State var deleteAlertInDisplay: Bool = false
        
    func streamView(streamModel: StreamModel<String>) -> some View {
        return AnyView(SingleStreamView(viewModel: DataStreamViewModel(streamModel: streamModel)))
    }
    
    var body: some View {
        ForEach(storedStreams) { stream in
            NavigationLink(destination: self.streamView(streamModel: stream)) {
                MenuRow(detailViewName: stream.name ?? "")
            }
        }.onDelete { (index) in
            guard let removingIndex = index.first else {
                return
            }
            if self.storedStreams[removingIndex].isDefault {
                self.deleteAlertInDisplay = true
                return
            }
            self.storedStreams.remove(at: removingIndex)
        }.onMove { (source, destination) in
            var storedStreams = self.storedStreams
            storedStreams.move(fromOffsets: source, toOffset: destination)
            self.storedStreams = storedStreams
        }.alert(isPresented: $deleteAlertInDisplay) { () -> Alert in
            Alert(title: Text("Don't do that"), message: Text("You can't delete default streams"), dismissButton: .cancel())
        }
    }
}

struct StreamListView_Previews: PreviewProvider {
    static var previews: some View {
        StreamListView(storedStreams: .constant([]))
    }
}
