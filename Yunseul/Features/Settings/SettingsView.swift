//
//  SettingsView.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    
    let store: Store<SettingsFeature.State, SettingsFeature.Action>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SettingsView(store: Store(initialState: SettingsFeature.State()) {
        SettingsFeature()
    })
}
