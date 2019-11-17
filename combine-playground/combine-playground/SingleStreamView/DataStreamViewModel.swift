//
//  DynamicStreamViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/28/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation

class DataStreamViewModel: StreamViewModel<String> {
    
    var streamModel: StreamModel<String> {
        didSet {
            self.title = self.streamModel.name ?? ""
            self.description = self.streamModel.description ?? ""
            self.publisher = self.streamModel.toPublisher()
        }
    }
    
    init(streamModel: StreamModel<String>) {        
        self.streamModel = streamModel        
        super.init(title: streamModel.name ?? "",
                   description: streamModel.description ?? streamModel.sequenceDescription,
                   publisher: self.streamModel.toPublisher())
    }
        
}
