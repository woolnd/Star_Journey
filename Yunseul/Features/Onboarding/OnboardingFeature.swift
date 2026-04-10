//
//  OnboardingFeature.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct OnboardingFeature {
    
    @ObservableState
    struct State: Equatable {
        var currentStep: Step = .nickname
        var nickname: String = ""
        var birthDate: Date = Date()
        var constellation: Constellation = .aries
        var constellationDescription: String = ""
        var isLoading: Bool = false
        
        enum Step: Equatable {
            case nickname
            case birthDate
            case result
        }
    }
    
    enum Action: Equatable {
        // 닉네임
        case nicknameChanged(String)
        case nicknameNextTapped
        
        // 생년월일
        case birthDateChanged(Date)
        case birthDateNextTapped
        
        // 별자리
        case constellationCalculated(Constellation)
        
        // 완료
        case beginTapped
        case saveCompleted
        case onboardingCompleted
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
                // MARK: - 닉네임
            case .nicknameChanged(let name):
                state.nickname = name
                return .none
                
            case .nicknameNextTapped:
                guard !state.nickname.trimmingCharacters(in: .whitespaces).isEmpty else {
                    return .none
                }
                state.currentStep = .birthDate
                return .none
                
                // MARK: - 생년월일
            case .birthDateChanged(let date):
                state.birthDate = date
                return .none
                
            case .birthDateNextTapped:
                let constellation = Constellation.from(date: state.birthDate)
                state.currentStep = .result
                return .send(.constellationCalculated(constellation))
                
                // MARK: - 별자리
            case .constellationCalculated(let constellation):
                state.constellation = constellation
                state.constellationDescription = constellation.description
                return .none
                
                // MARK: - 완료
            case .beginTapped:
                state.isLoading = true
                let nickname = state.nickname
                let birthDate = state.birthDate
                let constellation = state.constellation.rawValue
                
                return .run { send in
                    try CoreDataService.shared.saveBirthStar(
                        nickname: nickname,
                        birthDate: birthDate,
                        constellation: constellation
                    )
                    UserDefaults.standard.set(true, forKey: UserDefaults.Keys.isOnboardingCompleted)
                    await send(.saveCompleted)
                }
                
            case .saveCompleted:
                state.isLoading = false
                return .send(.onboardingCompleted)
                
            case .onboardingCompleted:
                return .none
            }
        }
    }
}
