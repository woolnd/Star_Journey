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
        var home = HomeFeature.State()
        var passport = PassportFeature.State()
        var settings = SettingsFeature.State()
        var selectedTap: Tab = .home
        
        enum Tab: Equatable {
            case home
            case passport
            case settings
        }
    }
    
    enum Action {
        case onboardingCompleted
        case home(HomeFeature.Action)
        case passport(PassportFeature.Action)
        case settings(SettingsFeature.Action)
        case tabSelected(State.Tab)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onboardingCompleted:
                state.isOnboardingCompleted = true
                return .none
                
            case .tabSelected(let tab):
                state.selectedTap = tab
                return .none
                
            case .home, .passport, .settings:
                return .none
            }
        }
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Scope(state: \.passport, action: \.passport) {
            PassportFeature()
        }
        Scope(state: \.settings, action: \.settings) {
            SettingsFeature()
        }
    }
}
