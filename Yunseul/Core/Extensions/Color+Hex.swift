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
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
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
