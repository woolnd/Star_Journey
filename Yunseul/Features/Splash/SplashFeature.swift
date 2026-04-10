//
//  SplashFeature.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SplashFeature {
    
    @ObservableState
    struct State: Equatable {
        var isFinished: Bool = false
    }
    
    enum Action: Equatable {
        case onAppear
        case splashFinished
        case checkOnboardingStatus
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    try await Task.sleep(nanoseconds: 2_500_000_000)
                    await send(.splashFinished)
                }
                
            case .checkOnboardingStatus:
                let isCompleted = UserDefaults.standard.bool(forKey: "isOnboardingCompleted")
                state.isFinished = true
                return .none
                
            case .splashFinished:
                state.isFinished = true
                return .none
            }
        }
    }
}
