//
//  NotificationService.swift
//  Yunseul
//
//  Created by wodnd on 4/12/26.
//

import Foundation
import UserNotifications

final class NotificationService {
    
    static let shared = NotificationService()
    private init() {}
    
    private let center = UNUserNotificationCenter.current()
    
    // MARK: - 권한 요청
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            print("🔔 [Notification] 권한 허용: \(granted)")
            return granted
        } catch {
            print("🔴 [Notification] 권한 요청 실패: \(error)")
            return false
        }
    }
    
    // MARK: - 권한 상태 확인
    func authorizationStatus() async -> UNAuthorizationStatus {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }
    
    // MARK: - 매일 밤 9시 별빛 알림 스케줄링
    func scheduleDailyStarNotification(
        constellation: Constellation,
        nickname: String
    ) {
        // 기존 알림 제거
        center.removePendingNotificationRequests(
            withIdentifiers: ["daily_star"]
        )
        
        let content = UNMutableNotificationContent()
        content.title = "✦ 오늘의 별빛"
        content.body = "\(nickname) 님의 \(constellation.rawValue)이 밤하늘을 여행하고 있어요. 오늘의 별빛을 기록해보세요."
        content.sound = .default
        
        // 매일 밤 9시
        var dateComponents = DateComponents()
        dateComponents.hour = 21
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "daily_star",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error {
                print("🔴 [Notification] 일일 알림 등록 실패: \(error)")
            } else {
                print("🔔 [Notification] 일일 알림 등록 성공 - 매일 밤 9시")
            }
        }
    }
    
    // MARK: - 성하점이 한국 근처일 때 특별 알림
    func scheduleKoreaProximityNotification(
        constellation: Constellation,
        nickname: String,
        subStellarLatitude: Double,
        subStellarLongitude: Double
    ) {
        // 한국 근방 체크 (위도 33~38, 경도 124~132)
        let isNearKorea = (33...38).contains(subStellarLatitude)
                       && (124...132).contains(subStellarLongitude)
        
        guard isNearKorea else { return }
        
        // 이미 오늘 보냈으면 중복 방지
        center.removePendingNotificationRequests(
            withIdentifiers: ["korea_proximity"]
        )
        
        let content = UNMutableNotificationContent()
        content.title = "🌟 특별한 순간"
        content.body = "지금 \(nickname) 님의 \(constellation.rawValue)이 한국 하늘 가까이 지나고 있어요! 지금 바로 하늘을 올려다보세요."
        content.sound = .default
        
        // 즉시 발송
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "korea_proximity",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error {
                print("🔴 [Notification] 한국 근접 알림 실패: \(error)")
            } else {
                print("🔔 [Notification] 한국 근접 알림 발송!")
            }
        }
    }
    
    // MARK: - 모든 알림 제거
    func removeAllNotifications() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        print("🔔 [Notification] 모든 알림 제거")
    }
}
