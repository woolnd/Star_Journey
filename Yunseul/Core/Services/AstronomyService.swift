//
//  AstronomyService.swift
//  Yunseul
//
//  Created by wodnd on 4/11/26.
//

import Foundation
import SwiftAA
import CoreLocation

final class AstronomyService {
    
    static let shared = AstronomyService()
    private init() {}
    
    // MARK: - 성하점 계산
    func subStellarPoint(
        constellation: Constellation,
        date: Date = Date()
    ) -> StarSubPoint {
        let jd = JulianDay(date)
        let equatorial = makeEquatorialCoordinates(for: constellation, julianDay: jd)
        let gst = jd.meanGreenwichSiderealTime()
        
        let raDeg = equatorial.rightAscension.value * 15.0  // Hour → Degree
        
        var longitude = gst.value * 15.0 - raDeg  // GST(도) - RA(도)
        
        // 정규화 -180 ~ 180
        longitude = longitude.truncatingRemainder(dividingBy: 360)
        if longitude > 180  { longitude -= 360 }
        if longitude < -180 { longitude += 360 }
        
        return StarSubPoint(
            latitude: equatorial.declination.value,
            longitude: longitude
        )
    }
    
    // MARK: - 지평 좌표 계산
    func horizontalCoordinates(
        constellation: Constellation,
        observerLatitude: Double,
        observerLongitude: Double,
        date: Date = Date()
    ) -> SwiftAA.HorizontalCoordinates {
        let jd = JulianDay(date)
        let equatorial = makeEquatorialCoordinates(for: constellation, julianDay: jd)
        
        let location = GeographicCoordinates(
            positivelyWestwardLongitude: Degree(-observerLongitude),
            latitude: Degree(observerLatitude)
        )
        
        // SwiftAA 지평 좌표 변환 + 대기굴절 보정 포함
        return equatorial.makeHorizontalCoordinates(for: location, at: jd)
    }
    
    // MARK: - 적도 좌표 생성
    private func makeEquatorialCoordinates(
        for constellation: Constellation,
        julianDay: JulianDay
    ) -> EquatorialCoordinates {
        let (ra, dec) = starCoordinates(for: constellation)
        
        // J2000.0 기준 좌표 생성 (세차운동 보정은 SwiftAA 내부에서 처리)
        return EquatorialCoordinates(
            rightAscension: Hour(ra),
            declination: Degree(dec),
            epoch: .J2000,
            equinox: .standardJ2000
        )
    }
    
    // MARK: - 별자리별 주성 좌표 (J2000.0)
    private func starCoordinates(for constellation: Constellation) -> (ra: Double, dec: Double) {
        switch constellation {
        case .aries:        return (2.5300,  23.4624)
        case .taurus:       return (4.5987,  16.5093)
        case .gemini:       return (7.7553,  28.0262)
        case .cancer:       return (8.2752,  9.1855)
        case .leo:          return (10.1395, 11.9672)
        case .virgo:        return (13.4199, -11.1613)
        case .libra:        return (15.2835, -9.3830)
        case .scorpio:      return (16.4901, -26.4320)
        case .sagittarius:  return (18.4029, -34.3846)
        case .capricorn:    return (21.7840, -16.1273)
        case .aquarius:     return (21.5260, -5.5711)
        case .pisces:       return (1.5242,  15.3457)
        }
    }
    
    // MARK: - 각도 정규화
    private func normalizeAngle(_ angle: Double) -> Double {
        var result = angle.truncatingRemainder(dividingBy: 360.0)
        if result < 0 { result += 360.0 }
        return result
    }
    
    // MARK: - 역지오코딩 (성하점 → 지역명)
    func regionName(latitude: Double, longitude: Double) async -> String {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "ko_KR")
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location, preferredLocale: locale)
            guard let placemark = placemarks.first else { return "알 수 없는 곳" }
            
            // 나라명 → 행정구역 순서로 반환
            if let country = placemark.country {
                // 바다일 경우 ocean 또는 administrativeArea 활용
                if let ocean = placemark.ocean {
                    return ocean  // "Pacific Ocean" 등
                }
                return country  // "대한민국", "United States" 등
            }
            
            if let ocean = placemark.ocean {
                return ocean
            }
            
            return placemark.administrativeArea ?? "알 수 없는 곳"
            
        } catch {
            return "알 수 없는 곳"
        }
    }
}

// MARK: - Double Extension
extension Double {
    var toRadians: Double { self * .pi / 180.0 }
    var toDegrees: Double { self * 180.0 / .pi }
}
