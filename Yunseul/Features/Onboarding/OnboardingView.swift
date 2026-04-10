//
//  OnboardingView.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
    
    let store: Store<OnboardingFeature.State, OnboardingFeature.Action>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    OnboardingView(store: Store(initialState: OnboardingFeature.State()) {
        OnboardingFeature()
    })
}
