//
//  AppFeature.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    
    @ObservableState
    struct State: Equatable {
        var isOnboardingCompleted: Bool = false
        var onboarding = OnboardingFeature.State()
        var home = HomeFeature.State()
        var traces = TracesFeature.State()
        var settings = SettingsFeature.State()
        var selectedTab: Tab = .home
        
        enum Tab: Equatable {
            case home
            case traces
            case settings
        }
    }
    
    enum Action {
        case onboardingCompleted
        case onboarding(OnboardingFeature.Action)
        case home(HomeFeature.Action)
        case traces(TracesFeature.Action)
        case settings(SettingsFeature.Action)
        case tabSelected(State.Tab)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onboardingCompleted:
                state.isOnboardingCompleted = true
                return .none
                
            case .tabSelected(let tab):
                state.selectedTab = tab
                return .none
                
            case .onboarding, .home, .traces, .settings:
                return .none
            }
        }
        Scope(state: \.onboarding, action: \.onboarding) {
            OnboardingFeature()
        }
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Scope(state: \.traces, action: \.traces) {
            TracesFeature()
        }
        Scope(state: \.settings, action: \.settings) {
            SettingsFeature()
        }
    }
}
