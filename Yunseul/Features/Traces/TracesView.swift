//
//  PassportView.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import SwiftUI
import ComposableArchitecture

struct TracesView: View {
    
    let store: Store<TracesFeature.State, TracesFeature.Action>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    TracesView(store: Store(initialState: TracesFeature.State()) {
        TracesFeature()
    })
}
