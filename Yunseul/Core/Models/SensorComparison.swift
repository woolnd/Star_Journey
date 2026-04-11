//
//  SensorComparison.swift
//  Yunseul
//
//  Created by wodnd on 4/11/26.
//

import Foundation

struct SensorComparison {
    let raw: Double        // 필터 전 값
    let filtered: Double   // 필터 후 값
    let difference: Double // 차이값 (노이즈 양)
    let timestamp: Date = Date()
}
