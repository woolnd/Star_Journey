//
//  AppView.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    
    let store: StoreOf<AppFeature>
    
    var body: some View {
        WithPerceptionTracking {
            if store.isOnboardingCompleted {
                MainTabView(store: store)
            } else {
                OnboardingView(store: store.scope(
                    state: \.onboarding, action: \.onboarding
                ))
            }
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
