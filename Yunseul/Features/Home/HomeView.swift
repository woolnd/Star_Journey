//
//  HomeView.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    
    let store: Store<HomeFeature.State, HomeFeature.Action>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HomeView(store: Store(initialState: HomeFeature.State()) {
        HomeFeature()
    })
}
