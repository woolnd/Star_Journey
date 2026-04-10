//
//  Color+Hex.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

extension Color {
    enum Yunseul {
        // 배경
        static let background    = Color(hex: "04060E")  // 심해 네이비
        static let surface       = Color(hex: "060C1E")  // 카드 배경
        static let elevated      = Color(hex: "080E24")  // 올라온 카드
        
        // 텍스트
        static let textPrimary   = Color(hex: "C2D3F5")  // 메인 텍스트 (밝은 블루화이트)
        static let textSecondary = Color(hex: "7A9FE0")  // 서브 텍스트 (별빛 블루) ← 밝게
        static let textTertiary  = Color(hex: "4A6AAA")  // 힌트 텍스트 ← 밝게
        
        // 강조
        static let starBlue      = Color(hex: "8AAEFF")  // 별빛 블루
        static let liveGreen     = Color(hex: "32D28C")  // 라이브 도트
        
        // 보더
        static let border        = Color(hex: "2A3D6A")  // 기본 보더
        static let borderFaint   = Color(hex: "1A2540")  // 희미한 보더
    }
}
