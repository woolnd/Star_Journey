//
//  SettingsFeature.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import ComposableArchitecture
import UserNotifications
import Foundation
import UIKit

@Reducer
struct SettingsFeature {
    
    @ObservableState
    struct State: Equatable {
        var nickname: String = {
            if let saved = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname),
               !saved.isEmpty { return saved }
            return (try? CoreDataService.shared.fetchBirthStar())?.nickname ?? ""
        }()
        
        var birthDate: Date = {
            if let saved = UserDefaults.standard.object(forKey: UserDefaults.Keys.birthDate) as? Date {
                return saved
            }
            return (try? CoreDataService.shared.fetchBirthStar())?.birthDate ?? Date()
        }()
        
        var constellation: Constellation = {
            if let name = UserDefaults.standard.string(forKey: UserDefaults.Keys.constellation),
               let c = Constellation(rawValue: name) { return c }
            if let name = (try? CoreDataService.shared.fetchBirthStar())?.constellation,
               let c = Constellation(rawValue: name) { return c }
            return .aries
        }()
        var isNotificationEnabled: Bool = UserDefaults.standard.bool(forKey: UserDefaults.Keys.isNotificationEnabled)
        
        // 시트 제어
        var isNicknameSheetPresented: Bool = false
        var isBirthDateSheetPresented: Bool = false
        
        // 임시 편집값
        var editingNickname: String = ""
        var editingBirthDate: Date = Date()
    }
    
    enum Action: Equatable {
        // 시트 열기/닫기
        case nicknameEditTapped
        case birthDateEditTapped
        case nicknameSheetDismissed
        case birthDateSheetDismissed
        
        // 편집 중
        case editingNicknameChanged(String)
        case editingBirthDateChanged(Date)
        
        // 저장
        case saveNickname
        case saveBirthDate
        
        // 알림 토글
        case notificationToggled(Bool)
        case notificationPermissionResponse(Bool)
        
        case onAppear
        case notificationStatusChecked(Bool)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
                // MARK: - 시트 열기
            case .nicknameEditTapped:
                state.editingNickname = state.nickname
                state.isNicknameSheetPresented = true
                return .none
                
            case .birthDateEditTapped:
                state.editingBirthDate = state.birthDate
                state.isBirthDateSheetPresented = true
                return .none
                
                // MARK: - 시트 닫기
            case .nicknameSheetDismissed:
                state.isNicknameSheetPresented = false
                return .none
                
            case .birthDateSheetDismissed:
                state.isBirthDateSheetPresented = false
                return .none
                
                // MARK: - 편집 중
            case let .editingNicknameChanged(nickname):
                state.editingNickname = nickname
                return .none
                
            case let .editingBirthDateChanged(date):
                state.editingBirthDate = date
                return .none
                
                // MARK: - 저장
            case .saveNickname:
                state.nickname = state.editingNickname
                state.isNicknameSheetPresented = false
                UserDefaults.standard.set(state.nickname, forKey: UserDefaults.Keys.nickname)
                return .none
                
            case .saveBirthDate:
                state.birthDate = state.editingBirthDate
                state.isBirthDateSheetPresented = false
                UserDefaults.standard.set(state.birthDate, forKey: UserDefaults.Keys.birthDate)
                
                let constellation = Constellation.from(date: state.editingBirthDate)
                state.constellation = constellation
                UserDefaults.standard.set(constellation.rawValue, forKey: UserDefaults.Keys.constellation)
                return .none
                
            case let .notificationPermissionResponse(granted):
                state.isNotificationEnabled = granted
                UserDefaults.standard.set(granted, forKey: UserDefaults.Keys.isNotificationEnabled)
                if granted {
                    
                    let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) ?? ""
                    let constellationName = UserDefaults.standard.string(forKey: UserDefaults.Keys.constellation) ?? "양자리"
                    let constellation = Constellation(rawValue: constellationName) ?? .aries
                    NotificationService.shared.scheduleDailyStarNotification(
                        constellation: constellation,
                        nickname: nickname
                    )
                }
                return .none
                
            case .onAppear:
                return .run { send in
                    let status = await NotificationService.shared.authorizationStatus()
                    let systemEnabled = status == .authorized || status == .provisional
                    await send(.notificationStatusChecked(systemEnabled))
                }
                
            case let .notificationStatusChecked(isEnabled):
                if !isEnabled {
                    state.isNotificationEnabled = false
                    UserDefaults.standard.set(false, forKey: UserDefaults.Keys.isNotificationEnabled)
                }
                return .none
                
            case let .notificationToggled(isEnabled):
                if isEnabled {
                    return .run { send in
                        let status = await NotificationService.shared.authorizationStatus()
                        
                        switch status {
                        case .authorized, .provisional:
                            await send(.notificationPermissionResponse(true))
                            
                        case .denied:
                            await MainActor.run {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                            await send(.notificationPermissionResponse(false))
                            
                        default:
                            let granted = await NotificationService.shared.requestAuthorization()
                            await send(.notificationPermissionResponse(granted))
                        }
                    }
                } else {
                    state.isNotificationEnabled = false
                    UserDefaults.standard.set(false, forKey: UserDefaults.Keys.isNotificationEnabled)
                    NotificationService.shared.removeAllNotifications()
                    return .none
                }
            }
        }
    }
}
