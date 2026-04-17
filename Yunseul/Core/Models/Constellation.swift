//
//  Constellation.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import Foundation

enum Constellation: String, Equatable, CaseIterable {
    case aries       = "aries"
    case taurus      = "taurus"
    case gemini      = "gemini"
    case cancer      = "cancer"
    case leo         = "leo"
    case virgo       = "virgo"
    case libra       = "libra"
    case scorpio     = "scorpio"
    case sagittarius = "sagittarius"
    case capricorn   = "capricorn"
    case aquarius    = "aquarius"
    case pisces      = "pisces"
    
    // 생년월일 → 별자리 계산
    static func from(date: Date) -> Constellation {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        switch (month, day) {
        case (3, 21...), (4, ...19): return .aries
        case (4, 20...), (5, ...20): return .taurus
        case (5, 21...), (6, ...21): return .gemini
        case (6, 22...), (7, ...22): return .cancer
        case (7, 23...), (8, ...22): return .leo
        case (8, 23...), (9, ...22): return .virgo
        case (9, 23...), (10, ...23): return .libra
        case (10, 24...), (11, ...22): return .scorpio
        case (11, 23...), (12, ...21): return .sagittarius
        case (12, 22...), (1, ...19): return .capricorn
        case (1, 20...), (2, ...18): return .aquarius
        default: return .pisces
        }
    }
    
    // 감성 설명
    var description: String {
        String(localized: "constellation.\(rawValue).description")
    }
    
    // 라틴어 이름
    var latinName: String {
        switch self {
        case .aries: return "Aries"
        case .taurus: return "Taurus"
        case .gemini: return "Gemini"
        case .cancer: return "Cancer"
        case .leo: return "Leo"
        case .virgo: return "Virgo"
        case .libra: return "Libra"
        case .scorpio: return "Scorpius"
        case .sagittarius: return "Sagittarius"
        case .capricorn: return "Capricornus"
        case .aquarius: return "Aquarius"
        case .pisces: return "Pisces"
        }
    }
    
    var imageName: String {
        switch self {
        case .aries:        return "aries"
        case .taurus:       return "taurus"
        case .gemini:       return "gemini"
        case .cancer:       return "cancer"
        case .leo:          return "leo"
        case .virgo:        return "virgo"
        case .libra:        return "libra"
        case .scorpio:      return "scorpio"
        case .sagittarius:  return "sagittarius"
        case .capricorn:    return "capricorn"
        case .aquarius:     return "aquarius"
        case .pisces:       return "pisces"
        }
    }
    
    var localizedName: String {
        String(localized: "constellation.\(rawValue).name")
    }
}

// MARK: - 별 이야기 페이지 모델
struct StoryPage: Equatable {
    let title: String
    let content: String
}

// MARK: - 별자리 관계 모델
struct StarRelation: Equatable {
    let type: String
    let constellation: String
    let description: String
    let icon: String
}

extension Constellation {
    var storyPages: [StoryPage] {
        (1...4).map { i in
            StoryPage(
                title: String(localized: "constellation.\(rawValue).story.\(i).title"),
                content: String(localized: "constellation.\(rawValue).story.\(i).content")
            )
        }
    }
}

extension Constellation {
    var relations: [StarRelation] {
        (1...4).map { i in
            StarRelation(
                type: String(localized: "constellation.\(rawValue).relation.\(i).type"),
                constellation: String(localized: "constellation.\(rawValue).relation.\(i).name"),
                description: String(localized: "constellation.\(rawValue).relation.\(i).desc"),
                icon: relationIcon(i)
            )
        }
    }
    
    private func relationIcon(_ index: Int) -> String {
        switch (self, index) {
        case (.scorpio, 2): return "bolt.fill"
        default:
            switch index {
            case 1: return "star.fill"
            case 2: return "link"
            case 3: return "moon.stars.fill"
            case 4: return "arrow.left.arrow.right"
            default: return "star.fill"
            }
        }
    }
}
