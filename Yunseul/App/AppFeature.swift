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
                UserDefaults.standard.set(true, forKey: UserDefaults.Keys.isOnboardingCompleted)
            
                state.settings.nickname = state.onboarding.nickname
                state.settings.birthDate = state.onboarding.birthDate
                state.settings.constellation = state.onboarding.constellation
                return .none
                
            case .onboardingCompleted:
                return .none
                
            case .tabSelected(let tab):
                state.selectedTab = tab
                return .none
                
            case .settings(.saveNickname):
                state.home.nickname = state.settings.nickname
                state.home.briefingText = "\(state.settings.nickname) 님의 별은 지금\n\(state.home.cachedRegionName)을 비추고 있어요"
                return .none
                
            case .settings(.saveBirthDate):
                let constellationName = UserDefaults.standard.string(forKey: UserDefaults.Keys.constellation) ?? "양자리"
                let constellation = Constellation(rawValue: constellationName) ?? .aries
                state.home.constellation = constellation
                state.settings.constellation = constellation
                state.home.cachedRegionName = ""
                
                return .run { send in
                    await StarTrailService.shared.recalculateAllTrails(constellation: constellation)
                    await send(.home(.calculateStarPosition))
                    await send(.traces(.onAppear))
                }
                
            case .home(.onAppear):
                return .run { send in
                    let status = await NotificationService.shared.authorizationStatus()
                    let isEnabled = status == .authorized || status == .provisional
                    await send(.settings(.notificationStatusChecked(isEnabled)))
                }
                
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
