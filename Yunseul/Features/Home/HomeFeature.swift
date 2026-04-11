//
//  HomeFeature.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import ComposableArchitecture
import CoreLocation
import SwiftAA
import RxSwift

@Reducer
struct HomeFeature {
    
    @ObservableState
    struct State: Equatable {
        
        // MARK: - 별 정보
        var constellation: Constellation = .aries
        var nickname: String = ""
        
        // MARK: - 성하점
        var subStellarLatitude: Double = 0
        var subStellarLongitude: Double = 0
        
        // MARK: - 지평 좌표
        var starAltitude: Double = 0
        var starAzimuth: Double = 0
        
        // MARK: - 감성 브리핑 텍스트
        var briefingText: String = ""
        
        // MARK: - 센서 데이터 (칼만 필터 제거)
        var deviceAzimuth: Double = 0   // 폰 방위각
        var deviceAltitude: Double = 0  // 폰 고도각
        
        // MARK: - 현재 위치
        var userLatitude: Double = 0
        var userLongitude: Double = 0
        
        // MARK: - UI 상태
        var isLoading: Bool = false
        var isCompassMode: Bool = false
        var locationAuthorizationDenied: Bool = false
        
        // MARK: - 별까지 각도 차이
        var azimuthDiff: Double = 0
        var altitudeDiff: Double = 0
        var isStarAligned: Bool = false
    }
    
    enum Action: Equatable {
        // MARK: - 라이프사이클
        case onAppear
        case onDisappear
        
        // MARK: - 위치
        case locationUpdated(latitude: Double, longitude: Double)
        case locationAuthorizationDenied
        
        // MARK: - 천문 계산
        case calculateStarPosition
        case starPositionUpdated(
            subPoint: StarSubPointEquatable,
            altitude: Double,
            azimuth: Double,
            briefing: String
        )
        
        // MARK: - 센서
        case sensorUpdated(azimuth: Double, altitude: Double)
        
        // MARK: - UI
        case compassModeOpen
        case compassModeClose
        case timerTicked
    }
    
    private let astronomyService = AstronomyService.shared
    private let locationService  = LocationService.shared
    private let motionService    = MotionService.shared
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            // MARK: - 앱 진입
            case .onAppear:
                state.isLoading = true
                
                if let birthStar = try? CoreDataService.shared.fetchBirthStar() {
                    state.constellation = Constellation(rawValue: birthStar.constellation ?? "") ?? .aries
                    state.nickname = birthStar.nickname ?? ""
                }
                
                return .merge(
                    .run { _ in locationService.requestPermissionAndStart() },
                    .run { _ in motionService.start() },
                    .send(.calculateStarPosition),
                    .run { send in
                        while true {
                            try await Task.sleep(nanoseconds: 15_000_000_000)
                            await send(.timerTicked)
                        }
                    }
                )
                
            case .onDisappear:
                locationService.stop()
                motionService.stop()
                return .none
                
            // MARK: - 위치 업데이트
            case let .locationUpdated(lat, lon):
                state.userLatitude  = lat
                state.userLongitude = lon
                return .send(.calculateStarPosition)
                
            case .locationAuthorizationDenied:
                state.locationAuthorizationDenied = true
                return .none
                
            // MARK: - 천문 계산
            case .calculateStarPosition:
                let constellation = state.constellation
                let userLatitude  = state.userLatitude  == 0 ? 37.5665  : state.userLatitude
                let userLongitude = state.userLongitude == 0 ? 126.9780 : state.userLongitude
                let nickname      = state.nickname
                
                return .run { send in
                    let subPoint = astronomyService.subStellarPoint(constellation: constellation)
                    
                    let horizontal = astronomyService.horizontalCoordinates(
                        constellation: constellation,
                        observerLatitude: userLatitude,
                        observerLongitude: userLongitude
                    )
                    
                    // CLGeocoder로 지역명 가져오기
                    let region = await astronomyService.regionName(
                        latitude: subPoint.latitude,
                        longitude: subPoint.longitude
                    )
                    
                    let briefing = "\(nickname) 님의 별은 지금\n\(region)을 비추고 있어요"
                    
                    await send(.starPositionUpdated(
                        subPoint: StarSubPointEquatable(
                            latitude: subPoint.latitude,
                            longitude: subPoint.longitude
                        ),
                        altitude: horizontal.altitude.value,
                        azimuth: horizontal.northBasedAzimuth.value,
                        briefing: briefing
                    ))
                }
                
            case let .starPositionUpdated(subPoint, altitude, azimuth, briefing):
                state.isLoading           = false
                state.subStellarLatitude  = subPoint.latitude
                state.subStellarLongitude = subPoint.longitude
                state.starAltitude        = altitude
                state.starAzimuth         = azimuth
                state.briefingText        = briefing
                return .none
                
            // MARK: - 센서 업데이트
            case let .sensorUpdated(azimuth, altitude):
                state.deviceAzimuth  = azimuth
                state.deviceAltitude = altitude
                state.azimuthDiff    = angleDiff(state.starAzimuth, azimuth)
                state.altitudeDiff   = state.starAltitude - altitude
                state.isStarAligned  = abs(state.azimuthDiff) < 2.0
                                    && abs(state.altitudeDiff) < 2.0
                return .none
                
            // MARK: - UI
            case .compassModeOpen:
                state.isCompassMode = true
                return .none
                
            case .compassModeClose:
                state.isCompassMode = false
                return .none
                
            case .timerTicked:
                return .send(.calculateStarPosition)
            }
        }
    }
    
    // MARK: - 각도 차이 계산 (-180 ~ 180)
    private func angleDiff(_ a: Double, _ b: Double) -> Double {
        var diff = a - b
        if diff >  180 { diff -= 360 }
        if diff < -180 { diff += 360 }
        return diff
    }
}

// MARK: - Equatable 래퍼
struct StarSubPointEquatable: Equatable {
    let latitude: Double
    let longitude: Double
}
