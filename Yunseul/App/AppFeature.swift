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
        var isSplashFinished: Bool = false
        var isOnboardingCompleted: Bool = false
        var splash = SplashFeature.State()
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
        case splash(SplashFeature.Action)
        case splashFinished
        case checkOnboardingStatus
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
                
            case .splash(.splashFinished):
                return .send(.checkOnboardingStatus)
                
            case .checkOnboardingStatus:
                let isCompleted = UserDefaults.standard.bool(
                    forKey: UserDefaults.Keys.isOnboardingCompleted
                )
                state.isSplashFinished = true
                state.isOnboardingCompleted = isCompleted
                return .none
                
            case .splashFinished:
                state.isSplashFinished = true
                return .none
                
            case .onboarding(.onboardingCompleted):
                state.isOnboardingCompleted = true
                UserDefaults.standard.set(
                    true,
                    forKey: UserDefaults.Keys.isOnboardingCompleted
                )
                return .none
                
            case .onboardingCompleted:
                return .none
                
            case .tabSelected(let tab):
                state.selectedTab = tab
                return .none
                
            case .splash, .onboarding, .home, .traces, .settings:
                return .none
            }
        }
        Scope(state: \.splash, action: \.splash) {
            SplashFeature()
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
