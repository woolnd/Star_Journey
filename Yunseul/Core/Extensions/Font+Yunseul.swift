//
//  Font+Yunseul.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import Foundation
import SwiftUI

extension Font {
    enum Yunseul {
        // 타이틀
        static let largeTitle  = Font.custom("Georgia", size: 36)
        static let title       = Font.custom("Georgia", size: 28)
        static let title2      = Font.custom("Georgia", size: 24)
        static let title3      = Font.custom("Georgia", size: 20)
        
        // 바디
        static let body        = Font.custom("Georgia", size: 16)
        static let callout     = Font.custom("Georgia", size: 15)
        static let subheadline = Font.custom("Georgia", size: 14)
        static let footnote    = Font.custom("Georgia", size: 13)
        static let caption     = Font.custom("Georgia", size: 12)
        
        // 이탤릭
        static let titleItalic    = Font.custom("Georgia-Italic", size: 28)
        static let bodyItalic     = Font.custom("Georgia-Italic", size: 16)
        static let calloutItalic  = Font.custom("Georgia-Italic", size: 15)
        static let footnoteItalic = Font.custom("Georgia-Italic", size: 13)
    }
}
