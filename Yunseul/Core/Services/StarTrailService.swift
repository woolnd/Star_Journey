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
        let today = Date()
        
        guard let birthStar = try? CoreDataService.shared.fetchBirthStar(),
              let onboardingDate = birthStar.createdAt else { return }
        
        let lastDate = CoreDataService.shared.fetchLastTrailDate()
        
        var startDate: Date
        if let last = lastDate {
            startDate = calendar.date(byAdding: .day, value: 1, to: last) ?? today
        } else {
            startDate = calendar.startOfDay(for: onboardingDate)
        }
        
        var kstCalendar = Calendar.current
        kstCalendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        let hour = kstCalendar.component(.hour, from: today)
        
        let endDate: Date
        if hour < 21 {
            endDate = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        } else {
            endDate = today
        }
        
        guard startDate <= endDate else { return }
        
        var current = startDate
        while current <= endDate {
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
                byAdding: .day, value: 1, to: current
            ) else { break }
            current = next
        }
        
        print("✦ [StarTrail] 궤적 저장 완료 - \(startDate) ~ \(endDate)")
    }
}
