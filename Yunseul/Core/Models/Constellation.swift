//
//  Constellation.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import Foundation

enum Constellation: String, Equatable, CaseIterable {
    case aries       = "양자리"
    case taurus      = "황소자리"
    case gemini      = "쌍둥이자리"
    case cancer      = "게자리"
    case leo         = "사자자리"
    case virgo       = "처녀자리"
    case libra       = "천칭자리"
    case scorpio     = "전갈자리"
    case sagittarius = "사수자리"
    case capricorn   = "염소자리"
    case aquarius    = "물병자리"
    case pisces      = "물고기자리"
    
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
        switch self {
        case .aries:
            return "불꽃처럼 타오르는 당신의 별은\n어두운 바다 위를 가장 먼저 가르며\n새벽을 깨웁니다."
        case .taurus:
            return "깊고 고요한 대지처럼\n당신의 별은 흔들리지 않는 빛으로\n누군가의 밤을 지켜줍니다."
        case .gemini:
            return "두 개의 빛이 서로를 감싸며\n당신의 별은 세상 어딘가에서\n이야기를 속삭이고 있습니다."
        case .cancer:
            return "달이 바다를 품듯\n당신의 별은 조용히\n누군가의 곁을 비추고 있습니다."
        case .leo:
            return "밤하늘의 왕처럼\n당신의 별은 어디서든\n가장 밝게 빛나고 있습니다."
        case .virgo:
            return "섬세한 빛결로\n당신의 별은 누군가의 어둠 속\n작은 길을 밝혀주고 있습니다."
        case .libra:
            return "균형 잡힌 빛으로\n당신의 별은 고요한 바다 위\n잔물결을 만들고 있습니다."
        case .scorpio:
            return "깊은 바다 아래에서도\n당신의 별빛은 닿습니다\n아무도 모르는 곳까지."
        case .sagittarius:
            return "끝없이 나아가는 빛처럼\n당신의 별은 지금 이 순간도\n새로운 지평을 여행하고 있습니다."
        case .capricorn:
            return "오랜 시간을 견뎌온 빛\n당신의 별은 묵묵히\n누군가의 새벽을 기다립니다."
        case .aquarius:
            return "자유롭게 흐르는 물처럼\n당신의 별은 경계 없이\n세상 모든 곳을 비춥니다."
        case .pisces:
            return "꿈과 현실 사이\n당신의 별은 고요한 바다에 비치며\n누군가의 밤을 따뜻하게 합니다."
        }
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
}
