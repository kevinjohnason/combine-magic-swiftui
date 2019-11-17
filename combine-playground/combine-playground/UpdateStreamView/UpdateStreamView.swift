//
//  UpdateStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/27/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct UpdateStreamView: View {
    
    @ObservedObject var viewModel: UpdateStreamViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let tunnelPadding: CGFloat = 5        
    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 10) {
                TextField("Stream Name", text: $viewModel.streamName).font(.headline).padding()
                Text(viewModel.sequenceDescription).font(.body).padding()
                BallTunnelView(values: self.$viewModel.values, color: .red, padding: 5)
                    .overlayPreferenceValue(TunnelPreferenceKey.self) { preferences in
                        GeometryReader { reader in
                            VStack(spacing: 30) {
                                HStack {
                                    ForEach(self.viewModel.streamNumberOptions) { option in
                                        CircularTextView(forgroundColor: .white, backgroundColor: .red, draggable: true, viewModel: option)
                                            .gesture(self.dragBallGesture(reader: reader, ballViewModel: option))
                                    }
                                }
                                HStack {
                                    ForEach(self.viewModel.streamLetterOptions) { option in
                                        CircularTextView(forgroundColor: .white, backgroundColor: .green, draggable: true, viewModel: option)
                                        .gesture(self.dragBallGesture(reader: reader, ballViewModel: option))
                                    }
                                }
                            }.offset(x: 0, y: reader[preferences.bounds!].height * 2)
                        }
                }
            }
            Spacer()
            VStack(spacing: 10) {
                Button("Reset") {
                    self.viewModel.values.removeAll()
                }.foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.gray)
                Button("Save") {
                    self.viewModel.save()
                    self.presentationMode.wrappedValue.dismiss()
                }.foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
            }
        }
    }
    
    func dragBallGesture(reader: GeometryProxy, ballViewModel: CircularTextViewModel) -> some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged({ (gestureValue) in
                ballViewModel.offset = CGSize(width: gestureValue.translation.width,
                                              height: gestureValue.translation.height)
            })
            .onEnded({ (gestureValue) in
                ballViewModel.offset = CGSize.zero
                guard reader.frame(in: .global).contains(gestureValue.location) else {
                    return
                }
                self.viewModel.values.append(TimeSeriesValue(value: ballViewModel.value))
                ballViewModel.isHidden = true
                let presentAnimation =  Animation.default.delay(0.5)
                withAnimation(presentAnimation) {
                    ballViewModel.isHidden = false
                }
            })                
    }
}

struct UpdateStreamView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateStreamView(viewModel: UpdateStreamViewModel(streamModel: StreamModel<String>(id: UUID(), name: "", description: nil, stream: [])))
    }
}
