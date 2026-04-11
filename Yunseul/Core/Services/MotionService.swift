//
//  MotionService.swift
//  Yunseul
//
//  Created by wodnd on 4/11/26.
//

import Foundation
import CoreMotion
import CoreLocation
import RxSwift

final class MotionService {
    
    static let shared = MotionService()
    private init() {}
    
    private let motionManager = CMMotionManager()
    private let haedingManager = CLLocationManager()
    
    // MARK: - 업데이트 주기
    private let updateInterval: TimeInterval = 1.0 / 30.0
    
    // MARK: - Raw 데이터 Subject
    private let rawAzimuthSubject = PublishSubject<Double>()
    private let rawAltitudeSubject = PublishSubject<Double>()
    private let rawPitchSubject = PublishSubject<Double>()
    private let rawRollSubject = PublishSubject<Double>()
    
    // MARK: - Raw 스트림
    var rawAzimuth: Observable<Double> { rawAzimuthSubject.asObservable() }
    var rawAltitude: Observable<Double> { rawAltitudeSubject.asObservable() }
    var rawPitch: Observable<Double> { rawPitchSubject.asObservable() }
    var rawRoll: Observable<Double> {
        rawRollSubject.asObservable()
    }
    
    // MARK: - 기기 자세 (pitch + roll 합산한 고도각)
    // pitch: 앞뒤 기울기, roll: 좌우 기울기
    var rawDeviceAltitude: Observable<Double> {
        return Observable.combineLatest(rawPitch, rawRoll) { pitch, roll in
            
            return pitch * 180.0 / .pi
        }
    }
    
    // MARK: - 시작
    func start() {
        startDeviceMotion()
    }
    
    // MARK: - 주이
    func stop() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    // MARK: - CoreMotion 시작
    private func startDeviceMotion() {
        guard motionManager.isDeviceMotionActive else { return }
        
        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.startDeviceMotionUpdates(
            using: .xMagneticNorthZVertical,
            to: .main
        ) { [weak self] motion, error in
            guard let self, let motion, error == nil else { return }
            
            let attitude = motion.attitude
            let heading = motion.heading
            
            // Raw 데이터 방출
            self.rawAzimuthSubject.onNext(heading)
            self.rawPitchSubject.onNext(attitude.pitch)
            self.rawRollSubject.onNext(attitude.roll)
            
            // 고도각 = pitch를 도 단위로 변환
            let altitudeDeg = attitude.pitch * 180.0 / .pi
            self.rawAltitudeSubject.onNext(altitudeDeg)
        }
    }
}
