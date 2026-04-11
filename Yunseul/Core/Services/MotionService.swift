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
    
    // MARK: - 업데이트 주기
    private let updateInterval: TimeInterval = 1.0 / 30.0
    
    // MARK: - 데이터 Subject
    private let azimuthSubject  = PublishSubject<Double>()
    private let altitudeSubject = PublishSubject<Double>()
    private let pitchSubject    = PublishSubject<Double>()
    private let rollSubject     = PublishSubject<Double>()
    
    // MARK: - 스트림
    var azimuth:  Observable<Double> { azimuthSubject.asObservable() }
    var altitude: Observable<Double> { altitudeSubject.asObservable() }
    var pitch:    Observable<Double> { pitchSubject.asObservable() }
    var roll:     Observable<Double> { rollSubject.asObservable() }
    
    // MARK: - 시작
    func start() {
        guard motionManager.isDeviceMotionAvailable else { return }
        
        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.startDeviceMotionUpdates(
            using: .xMagneticNorthZVertical,
            to: .main
        ) { [weak self] motion, error in
            guard let self, let motion, error == nil else { return }
            
            let attitude    = motion.attitude
            let heading     = motion.heading
            let altitudeDeg = attitude.pitch * 180.0 / .pi
            
            self.azimuthSubject.onNext(heading)
            self.altitudeSubject.onNext(altitudeDeg)
            self.pitchSubject.onNext(attitude.pitch)
            self.rollSubject.onNext(attitude.roll)
        }
    }
    
    // MARK: - 중지
    func stop() {
        motionManager.stopDeviceMotionUpdates()
    }
}
