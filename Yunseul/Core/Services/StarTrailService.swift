//
//  StarTrailService.swift
//  Yunseul
//
//  Created by wodnd on 4/13/26.
//

import Foundation

final class StarTrailService {
    
    static let shared = StarTrailService()
    private init() {}
    
    private let astronomyService = AstronomyService.shared
    private let coreDataService  = CoreDataService.shared
    
    // MARK: - 빠진 날짜 소급 저장
    // StarTrailService.swift 수정
    func fillMissingDates(constellation: Constellation) async {
        let calendar = Calendar.current
        let today    = Date()
        
        guard let birthStar = try? CoreDataService.shared.fetchBirthStar(),
              let onboardingDate = birthStar.createdAt else {
            print("✦ [StarTrail] 온보딩 완료일 없음")
            return
        }
        
        // 마지막 저장일 확인
        let lastDate = CoreDataService.shared.fetchLastTrailDate()
        
        // 시작일 결정
        // 온보딩 완료일과 마지막 저장일 중 더 최근 날짜 기준
        var startDate: Date
        if let last = lastDate {
            startDate = calendar.date(byAdding: .day, value: 1, to: last) ?? today
        } else {
            startDate = calendar.startOfDay(for: onboardingDate)  // ✅ 온보딩 완료일부터
        }
        
        guard startDate <= today else { return }
        
        var current = startDate
        while current <= today {
            let subPoint = astronomyService.subStellarPoint(
                constellation: constellation,
                date: current
            )
            
            let region = await astronomyService.regionName(
                latitude: subPoint.latitude,
                longitude: subPoint.longitude
            )
            
            CoreDataService.shared.saveTrailEntry(
                date: current,
                latitude: subPoint.latitude,
                longitude: subPoint.longitude,
                regionName: region,
                constellation: constellation.rawValue
            )
            
            guard let next = calendar.date(
                byAdding: .day,
                value: 1,
                to: current
            ) else { break }
            current = next
        }
        
        print("✦ [StarTrail] 궤적 저장 완료 - \(startDate) ~ \(today)")
    }
}
