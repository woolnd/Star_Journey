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
        // MARK: - UI - 에스코어드림
        static let title3         = Font.custom("SCDream6", size: 20)
        static let subheadline    = Font.custom("SCDream5", size: 15)
        static let callout        = Font.custom("SCDream5", size: 14)
        static let footnote       = Font.custom("SCDream4", size: 13)
        static let footnoteItalic = Font.custom("SCDream4", size: 13)
        static let caption        = Font.custom("SCDream3", size: 11)
        static let captionLight   = Font.custom("SCDream3", size: 10)
        
        // MARK: - 감성 - 마포꽃섬
        static let story             = Font.custom("MapoFlowerIsland", size: 15)
        static let storyLarge        = Font.custom("MapoFlowerIsland", size: 20)
        static let storyTitle        = Font.custom("MapoFlowerIsland", size: 20)
        static let constellationName = Font.custom("MapoFlowerIsland", size: 28)
        static let constellationSub  = Font.custom("MapoFlowerIsland", size: 14)
        
        // MARK: - 앱 타이틀 - 마포꽃섬
        static let appTitle          = Font.custom("MapoFlowerIsland", size: 36)
        static let appSubtitle       = Font.custom("MapoFlowerIsland", size: 13)
        
        // MARK: - 브리핑 텍스트
        static let briefing          = Font.custom("SCDream4", size: 18)
        static let briefingSmall     = Font.custom("SCDream3", size: 14)
    }
}
