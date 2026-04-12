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
        // 배경 (블루그레이 - 채도 낮춤)
        static let background    = Color(hex: "E8EAED")
        static let surface       = Color(hex: "E0E2E7")
        static let elevated      = Color(hex: "D8DBE2")

        // 텍스트
        static let textPrimary   = Color(hex: "1A1D23")
        static let textSecondary = Color(hex: "5C6478")
        static let textTertiary  = Color(hex: "9BA3B5")

        // 강조
        static let starBlue      = Color(hex: "4A7DE0")
        static let liveGreen     = Color(hex: "28B085")

        // 보더
        static let border        = Color(hex: "C8CCD8")
        static let borderFaint   = Color(hex: "D8DBE8")

        // 성운
        static let nebula1       = Color(hex: "B8C4D8")
        static let nebula2       = Color(hex: "C0CCD8")  
    }
}
