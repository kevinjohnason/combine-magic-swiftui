//
//  MenuRow.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct MenuRow: View {
    
    let detailViewName: String
    
    var body: some View {
        Text(detailViewName)
    }
}

#if DEBUG
struct MenuRow_Previews: PreviewProvider {
    static var previews: some View {
        MenuRow(detailViewName: "Single Stream")
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
#endif
