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
        WithViewStore(store, observe: { $0 }) { viewStore in
            if !viewStore.isSplashFinished {
                SplashView(store: store.scope(
                    state: \.splash,
                    action: \.splash
                ))
            } else if !viewStore.isOnboardingCompleted {
                OnboardingView(store: store.scope(
                    state: \.onboarding,
                    action: \.onboarding
                ))
            } else {
                MainTabView(store: store)
            }        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
