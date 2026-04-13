//
//  LocationService.swift
//  Yunseul
//
//  Created by wodnd on 4/11/26.
//

import Foundation
import CoreLocation
import RxSwift

final class LocationService: NSObject {
    
    static let shared = LocationService()
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private let manager = CLLocationManager()
    
    // MARK: - 현재 위치 스트림
    private let locationSubject = PublishSubject<CLLocation>()
    var location: Observable<CLLocation> {
        return locationSubject.asObservable()
    }
    
    // MARK: - 권한 상태 스트림
    private let authorizationSubject = BehaviorSubject<CLAuthorizationStatus>(
        value: .notDetermined
    )
    
    var authorizationStatus: Observable<CLAuthorizationStatus> {
        return authorizationSubject.asObservable()
    }
    
    // MARK: - 위도/경도만 추출한 스트림
    var coordinate: Observable<(latitude: Double, longitude: Double)> {
        
        return location.map { location in
            (
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        }
    }
    
    // MARK: - 권한 요청 및 시작
    func requestPermissionAndStart() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    // MARK: - 중지
    func stop() {
        manager.stopUpdatingLocation()
    }

    // 권한 결정까지 대기하는 함수 추가
    func requestAuthorizationAndWait() async {
        let current = manager.authorizationStatus
        guard current == .notDetermined else {
            // 이미 결정된 상태면 바로 시작
            if current == .authorizedWhenInUse || current == .authorizedAlways {
                manager.startUpdatingLocation()
            }
            return
        }
        
        return await withCheckedContinuation { continuation in
            manager.requestWhenInUseAuthorization()
            
            // 권한 상태 변경 감지
            _ = authorizationSubject
                .filter { $0 != .notDetermined }
                .take(1)
                .subscribe(onNext: { status in
                    if status == .authorizedWhenInUse || status == .authorizedAlways {
                        self.manager.startUpdatingLocation()
                    }
                    continuation.resume()
                })
        }
    }

    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate/
extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }
        
        // 정확도 필터링 100m 이상 오차면 무시
        guard location.horizontalAccuracy < 100 else { return }
        locationSubject.onNext(location)
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        authorizationSubject.onNext(status)
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Location error: \(error.localizedDescription)")
    }
}
