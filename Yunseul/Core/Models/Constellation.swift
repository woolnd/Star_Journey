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
        switch self {
            
        case .aries:
            return [
                StoryPage(title: "탄생", content: """
                    오래전, 신들이 아직 땅 위를 거닐던 시절의 이야기예요.

                    보이오티아의 왕 아타마스에게는 두 아이가 있었어요. 프릭소스와 헬레. 그러나 새 왕비 이노는 두 아이를 미워했고, 몰래 나라의 씨앗을 모두 볶아버렸어요. 흉년이 들자 신탁을 조작해 아이들을 제물로 바치라 했죠.

                    그 순간, 황금빛 털을 가진 신성한 숫양 한 마리가 하늘에서 내려왔어요. 헤르메스가 보낸 양이었죠. 양은 아이들을 등에 태우고 폭풍 속을 가로질러 하늘로 날아올랐어요.

                    밤하늘의 별들이 길을 내어주었고, 바람조차 숨을 죽였습니다.
                    """),
                StoryPage(title: "여정", content: """
                    하늘을 가르며 달리던 양의 등 위에서, 헬레는 그만 손을 놓고 말았어요.

                    아래로 펼쳐진 바다 — 지금도 그 바다는 헬레스폰트라 불려요. 헬레의 이름을 간직한 채로.

                    홀로 남은 프릭소스는 꼭 붙들고, 양은 끝까지 달렸어요. 콜키스 땅에 닿았을 때, 프릭소스는 살아있었어요. 양은 신들에게 바쳐졌고, 황금빛 양털은 성스러운 숲에 걸렸죠.

                    그 황금 양털을 되찾으러 훗날 이아손이 아르고호를 이끌고 떠난다는 건, 또 다른 이야기예요.

                    양은 죽었지만, 제우스는 그를 하늘에 올렸어요. 용기와 희생을 기억하기 위해.
                    """),
                StoryPage(title: "Hamal — 양의 머리", content: """
                    양자리의 중심에는 Hamal이 있어요.

                    아랍어로 '양의 머리'를 뜻하는 이 별은, 지구에서 약 66광년 떨어진 곳에서 빛나고 있어요. 우리 태양보다 약 14배 밝고, 붉은빛을 띠는 거성이에요.

                    수천 년 전, 봄의 시작을 알리는 춘분점이 바로 이 별 근처에 있었어요. 농부들은 Hamal이 지평선에 뜨면 씨앗을 심었고, 어부들은 뱃길을 잡았죠.

                    지금은 세차운동으로 춘분점이 이동했지만, 오래된 별자리 표에는 아직도 양자리가 첫 번째로 적혀 있어요.

                    시작의 별. 봄의 기억을 품은 별.
                    """),
                StoryPage(title: "당신의 별", content: """
                    3월 21일부터 4월 19일 사이에 태어난 당신.

                    황금 양이 하늘로 올라간 그 자리에, 당신의 별이 새겨졌어요.

                    양자리는 시작을 두려워하지 않는 별이에요. 폭풍 속에서도 달렸고, 끝을 모르고 앞으로 나아갔죠. 그 용기가 지금 당신의 하늘 어딘가에서 조용히 빛나고 있어요.

                    오늘 밤, 하늘 어딘가에서 Hamal이 당신을 내려다보고 있을 거예요.

                    66광년의 거리를 넘어서, 오늘도.
                    """)
            ]

        case .taurus:
            return [
                StoryPage(title: "탄생", content: """
                    제우스는 종종 변신을 했어요. 독수리가 되기도, 백조가 되기도 했죠.

                    그러나 페니키아의 공주 에우로파를 보았을 때, 그는 눈부시게 흰 황소가 되었어요. 바닷가에서 꽃을 따던 에우로파는 그 아름다운 황소에게 다가갔고, 황소의 등에 올라탔어요.

                    그 순간, 황소는 달리기 시작했어요. 바다를 건너고, 파도를 가르며, 크레타 섬까지.

                    에우로파는 무서웠지만 손을 놓지 않았어요. 바람이 머리카락을 흩날렸고, 바다가 발아래에서 반짝였죠.

                    제우스는 그 황소를 하늘에 올려 영원히 기억했어요.
                    """),
                StoryPage(title: "플레이아데스 — 일곱 자매", content: """
                    황소자리 안에는 작은 별 무리가 있어요.

                    플레이아데스 — 아틀라스와 플레이오네의 일곱 딸들이에요. 사냥꾼 오리온이 그들을 쫓자, 제우스가 비둘기로 변신시켜 하늘로 올렸다고 해요.

                    일곱 자매 중 여섯은 밝게 빛나고, 하나는 보이지 않아요. 트로이가 멸망할 때 사라진 엘렉트라라는 전설도 있고, 인간과 사랑에 빠진 메로페가 부끄러워 숨었다는 이야기도 있죠.

                    맑은 날 밤, 황소자리 어깨 부근을 보면 그 자매들을 만날 수 있어요. 조용히, 다정하게 모여 있는.
                    """),
                StoryPage(title: "Aldebaran — 황소의 눈", content: """
                    황소자리의 중심, Aldebaran.

                    아랍어로 '따라오는 자'라는 뜻이에요. 플레이아데스를 따라 하늘을 가로지르기 때문에 붙은 이름이죠.

                    지구에서 약 65광년 거리, 우리 태양보다 44배 큰 붉은 거성이에요. 황소의 눈처럼 붉게 빛나는 이 별은, 고대부터 항해사들의 길잡이였어요.

                    봄이 오기 전 겨울 밤하늘에, 오리온자리 옆에서 붉게 반짝이는 별이 보인다면 그게 Aldebaran이에요.

                    65광년의 거리에서도, 그 붉은 눈빛은 선명해요.
                    """),
                StoryPage(title: "당신의 별", content: """
                    4월 20일부터 5월 20일 사이에 태어난 당신.

                    황소는 느리지만 멈추지 않는 별이에요. 폭풍 속에서 제우스가 선택한 모습이 황소였던 건, 우연이 아니었을 거예요.

                    흔들리지 않는 것. 자신의 속도로 걷는 것. 그 안에 담긴 단단함이 당신의 별에 새겨져 있어요.

                    오늘 밤 Aldebaran이 붉게 빛나고 있다면, 그건 65광년 너머에서 당신에게 보내는 신호예요.
                    """)
            ]

        case .gemini:
            return [
                StoryPage(title: "탄생", content: """
                    하늘에서 가장 다정한 별자리가 있다면, 쌍둥이자리일 거예요.

                    카스토르와 폴룩스 — 같은 어머니 레다에게서 태어났지만, 아버지는 달랐어요. 카스토르는 인간의 아들, 폴룩스는 제우스의 아들이었죠.

                    그래서 카스토르는 죽을 수밖에 없는 운명이었고, 폴룩스는 영원히 살 수 있었어요.

                    카스토르가 전쟁에서 죽었을 때, 폴룩스는 제우스에게 간청했어요. 자신의 불멸을 나눠달라고. 형과 함께 있게 해달라고.

                    제우스는 그 마음을 받아, 둘을 하늘에 나란히 올렸어요.
                    """),
                StoryPage(title: "아르고호의 영웅들", content: """
                    카스토르와 폴룩스는 이아손의 아르고호 원정대에 함께했어요.

                    카스토르는 말을 길들이는 데 뛰어났고, 폴룩스는 권투의 달인이었죠. 두 형제는 언제나 붙어다니며 서로를 지켰어요.

                    항해 중 거센 폭풍이 몰아쳤을 때, 선원들은 두 형제의 머리 위에서 빛나는 불꽃을 보았다고 해요. 그 빛이 폭풍을 잠재웠다는 전설이 있어요.

                    지금도 배에서 두 개의 불빛이 보이면 '카스토르와 폴룩스가 함께한다'고 말해요. 안전의 표시로.
                    """),
                StoryPage(title: "두 별의 비밀", content: """
                    카스토르와 폴룩스는 하늘에서도 나란히 빛나요.

                    카스토르는 사실 여섯 개의 별이 서로 공전하는 복잡한 계예요. 지구에서 약 51광년 거리에 있죠. 폴룩스는 28광년으로 더 가깝고, 쌍둥이자리에서 가장 밝은 별이에요.

                    두 별은 밤하늘에서 2도 정도밖에 떨어져 있지 않아요. 언제나 붙어 다니는 형제처럼.

                    겨울 밤하늘, 오리온자리 위를 보면 나란히 빛나는 두 별을 찾을 수 있어요.
                    """),
                StoryPage(title: "당신의 별", content: """
                    5월 21일부터 6월 21일 사이에 태어난 당신.

                    쌍둥이자리는 혼자가 아닌 별이에요. 언제나 둘이고, 나눔을 아는 별이죠.

                    폴룩스가 불멸을 나눴듯, 당신 안에도 그런 마음이 있을 거예요. 소중한 것을 함께 나누고 싶은.

                    오늘 밤 두 별이 나란히 빛나고 있다면, 그건 당신 곁에 누군가 있다는 신호일지도 몰라요.
                    """)
            ]

        case .cancer:
            return [
                StoryPage(title: "탄생", content: """
                    헤라클레스가 레르나의 히드라와 싸우던 날, 헤라는 그를 방해하려 했어요.

                    바닷속에서 게 한 마리를 보내 헤라클레스의 발을 물게 했죠. 작은 게였어요. 헤라클레스는 그 게를 밟아버렸고, 게는 그렇게 죽었어요.

                    헤라는 그 충성스러운 게가 안타까워 하늘로 올렸어요. 비록 임무는 실패했지만, 끝까지 자리를 지켰으니까요.

                    결과보다 마음이 중요하다는 걸, 게자리는 알고 있어요.
                    """),
                StoryPage(title: "프레세페 — 별들의 벌집", content: """
                    게자리 한가운데에는 프레세페라는 별 무리가 있어요.

                    맨눈으로 보면 뿌연 구름처럼 보이지만, 망원경으로 보면 수백 개의 별이 모여있는 성단이에요. 거리는 약 577광년.

                    고대 그리스에서는 이 흐릿한 빛을 '당나귀들의 여물통'이라 불렀어요. 게자리 양쪽의 두 별이 당나귀이고, 프레세페가 여물통이라는 거예요.

                    맑은 밤, 게자리를 찾아 중심을 바라보면 그 희미한 빛을 볼 수 있어요. 수백 개의 별이 함께 만드는 빛.
                    """),
                StoryPage(title: "여름 하늘의 길목", content: """
                    게자리는 황도 위에 있어요.

                    태양, 달, 행성들이 지나가는 길목에 자리잡고 있죠. 고대 천문학자들은 태양이 게자리에 들어올 때를 하지라고 불렀어요. 일 년 중 낮이 가장 긴 날.

                    지금은 세차운동으로 하지점이 이동했지만, 북회귀선의 영어 이름은 아직도 'Tropic of Cancer — 게자리의 선'이에요.

                    작고 어두운 별자리지만, 하늘의 중요한 표식이에요. 조용히, 제자리를 지키며.
                    """),
                StoryPage(title: "당신의 별", content: """
                    6월 22일부터 7월 22일 사이에 태어난 당신.

                    게자리는 조용한 별이에요. 화려하지 않지만, 끝까지 자리를 지키는 별이죠.

                    작은 게가 헤라클레스의 발을 물었던 것처럼, 당신도 포기하지 않는 마음을 알고 있을 거예요. 결과보다 그 마음이 중요하다는 것도.

                    오늘 밤, 조용히 빛나는 게자리를 찾아보세요. 수백 개의 별이 함께 당신을 바라보고 있을 거예요.
                    """)
            ]

        case .leo:
            return [
                StoryPage(title: "탄생", content: """
                    헤라클레스의 첫 번째 과업은 네메아의 사자를 죽이는 것이었어요.

                    보통 무기로는 상처조차 낼 수 없는 사자였죠. 헤라클레스는 결국 맨손으로 사자의 목을 졸라 쓰러뜨렸어요. 그리고 사자의 발톱으로 가죽을 벗겨 갑옷으로 삼았죠.

                    제우스는 그 강인한 사자를 하늘에 올렸어요. 적이었지만, 그 위엄은 영원히 기억될 자격이 있었으니까요.

                    사자자리는 봄 밤하늘의 왕이에요. 레굴루스가 그 심장에서 빛나고 있죠.
                    """),
                StoryPage(title: "봄 하늘의 왕", content: """
                    사자자리는 봄이 되면 남쪽 하늘에 높이 떠올라요.

                    머리 부분은 물음표를 뒤집어 놓은 것 같은 모양이에요. 이 부분을 '낫'이라고 부르죠. 사자가 하늘을 향해 포효하는 것처럼 보여요.

                    봄의 대삼각형 — 사자자리의 데네볼라, 처녀자리의 스피카, 목동자리의 아르크투루스가 만드는 거대한 삼각형이에요.

                    봄밤에 남쪽 하늘을 보면, 그 당당한 사자의 모습을 찾을 수 있어요.
                    """),
                StoryPage(title: "Regulus — 왕의 별", content: """
                    사자자리의 심장, Regulus.

                    라틴어로 '작은 왕'이라는 뜻이에요. 지구에서 약 79광년, 우리 태양보다 약 360배 밝은 별이에요.

                    고대부터 왕의 별로 여겨졌어요. 바빌로니아, 페르시아, 로마 모두 이 별을 왕권과 연결했죠.

                    레굴루스는 황도 위에 있어서, 달이 자주 이 별 앞을 지나가요. 달 뒤로 사라졌다가 다시 나타나는 레굴루스를 보면, 별도 숨을 쉰다는 느낌이 들어요.
                    """),
                StoryPage(title: "당신의 별", content: """
                    7월 23일부터 8월 22일 사이에 태어난 당신.

                    사자자리는 당당한 별이에요. 봄 하늘에서 가장 먼저 눈에 띄고, 레굴루스는 언제나 중심에서 빛나죠.

                    그 당당함이 당신 안에 있어요. 무리 속에서도 자신의 빛을 잃지 않는 것.

                    오늘 밤 레굴루스를 찾아보세요. 왕의 별이 당신을 알아볼 거예요.
                    """)
            ]

        case .virgo:
            return [
                StoryPage(title: "탄생", content: """
                    처녀자리는 데메테르, 혹은 페르세포네의 이야기예요.

                    대지의 여신 데메테르의 딸 페르세포네는 꽃밭에서 놀다가 하데스에게 납치되었어요. 데메테르는 딸을 찾아 온 세상을 헤맸고, 그동안 땅은 메말라갔어요.

                    결국 페르세포네는 6개월은 지하에서, 6개월은 땅 위에서 살게 되었어요. 페르세포네가 땅으로 올라오는 봄, 데메테르는 기뻐하며 대지를 풍요롭게 했죠.

                    처녀자리가 봄 하늘에 빛나는 건, 그 기쁨의 흔적이에요.
                    """),
                StoryPage(title: "아스트라이아의 저울", content: """
                    처녀자리는 정의의 여신 아스트라이아이기도 해요.

                    황금시대가 끝나고 인간이 타락해갈 때, 신들은 하나둘 하늘로 떠났어요. 아스트라이아는 가장 마지막까지 땅에 남아 정의를 지키려 했죠.

                    하늘로 올라갈 때, 그녀는 저울을 옆에 남겨두었어요. 그게 처녀자리 옆의 천칭자리예요.

                    처녀자리와 천칭자리는 그렇게 나란히 서 있어요. 정의와 균형, 함께.
                    """),
                StoryPage(title: "Spica — 밀 이삭", content: """
                    처녀자리의 가장 밝은 별, Spica.

                    라틴어로 '밀 이삭'이라는 뜻이에요. 처녀가 손에 든 밀 이삭이 별이 되었죠.

                    지구에서 약 250광년 거리에 있는 Spica는 사실 두 별이 서로를 공전하는 쌍성이에요. 너무 가까워서 서로의 중력으로 타원형으로 늘어났을 정도죠.

                    밤하늘에서 파란빛을 띠는 밝은 별이 보인다면, 그게 Spica예요.
                    """),
                StoryPage(title: "당신의 별", content: """
                    8월 23일부터 9월 22일 사이에 태어난 당신.

                    처녀자리는 섬세한 별이에요. 대지를 돌보고, 계절을 만들고, 풍요를 가져오는 별이죠.

                    그 세심함이 당신 안에 있어요. 작은 것도 놓치지 않는 눈, 조용히 돌보는 마음.

                    Spica가 파랗게 빛나는 밤, 그 빛이 250광년을 건너 당신에게 닿고 있어요.
                    """)
            ]

        case .libra:
            return [
                StoryPage(title: "탄생", content: """
                    천칭자리는 정의의 여신 아스트라이아의 저울이에요.

                    황금시대, 신들은 인간과 함께 살았어요. 그러나 인간이 타락하면서 신들은 하나둘 하늘로 떠났죠. 아스트라이아는 가장 마지막까지 땅에 남아 정의를 지키려 했어요.

                    결국 그녀도 하늘로 올라가며, 자신의 저울을 하늘에 걸어두었어요. 언젠가 다시 정의가 세상에 돌아오길 바라며.

                    천칭자리는 황도 12궁 중 유일하게 생명체가 아닌 사물이에요.
                    """),
                StoryPage(title: "저울의 비밀", content: """
                    천칭자리의 두 밝은 별에는 특별한 이름이 있어요.

                    주브라 알 아크라브 — '전갈의 남쪽 집게발'. 주브라 알 샤말리 — '전갈의 북쪽 집게발'.

                    이름에서 알 수 있듯, 오래전 천칭자리의 별들은 전갈자리의 일부로 여겨졌어요. 그러다 고대 로마 시대에 율리우스 카이사르를 기리며 새로운 별자리로 분리되었죠.

                    저울의 별들은 전갈의 기억을 이름에 품고 있어요. 지금도 그 흔적이 남아.
                    """),
                StoryPage(title: "균형의 시간", content: """
                    천칭자리는 춘분과 추분을 지키는 별이기도 해요.

                    낮과 밤의 길이가 같아지는 추분, 태양이 천칭자리 근처에 있어요. 균형이 이루어지는 그 순간.

                    고대인들은 추분을 한 해의 균형점으로 여겼어요. 수확을 마치고, 겨울을 준비하는 시간. 저울이 균형을 찾는 시간.

                    천칭자리가 뜨는 밤, 하늘도 잠시 균형을 찾아요.
                    """),
                StoryPage(title: "당신의 별", content: """
                    9월 23일부터 10월 23일 사이에 태어난 당신.

                    천칭자리는 균형을 아는 별이에요. 한쪽으로 치우치지 않으려는, 모든 것을 공평하게 보려는 마음.

                    아스트라이아가 마지막까지 땅에 남았던 것처럼, 당신도 포기하지 않는 정의감이 있을 거예요.

                    오늘 밤 저울이 균형을 찾고 있다면, 그건 당신 안에서도 일어나는 일이에요.
                    """)
            ]

        case .scorpio:
            return [
                StoryPage(title: "탄생", content: """
                    오리온은 세상에서 가장 위대한 사냥꾼이었어요. 그러나 그 자만심이 문제였죠.

                    "세상의 모든 짐승을 사냥하겠다"고 외쳤을 때, 대지의 여신 가이아는 분노했어요. 전갈 한 마리를 보냈고, 전갈은 오리온의 발꿈치를 물었어요.

                    그렇게 오리온은 쓰러졌어요. 제우스는 둘 다 하늘에 올렸지만, 같은 하늘에 있으면 싸울 것 같아 반대편에 두었어요.

                    영원히 만나지 못하게.
                    """),
                StoryPage(title: "여름 밤의 지배자", content: """
                    전갈자리는 여름 밤하늘의 주인이에요.

                    S자 모양으로 굽어진 몸체가 남쪽 하늘을 가로질러요. 한국에서는 지평선 가까이 낮게 떠 있어서, 맑고 탁 트인 곳에서 봐야 잘 보여요.

                    전갈자리 꼬리 근처에는 은하수가 가장 밝게 빛나는 곳이 있어요. 우리 은하의 중심 방향이죠.

                    여름 밤, 남쪽 하늘을 바라보면 붉은 안타레스와 함께 은하수가 쏟아지는 장면을 볼 수 있어요.
                    """),
                StoryPage(title: "Antares — 붉은 심장", content: """
                    전갈자리의 심장, Antares.

                    '화성의 경쟁자'라는 뜻이에요. 붉은빛이 화성과 너무 닮아서 붙은 이름이죠.

                    지구에서 약 550광년. 우리 태양의 700배 크기를 가진 적색 초거성이에요. 만약 태양 자리에 Antares를 놓는다면, 화성 궤도까지 삼켜버릴 크기예요.

                    언젠가 Antares는 초신성 폭발로 생을 마칠 거예요. 지금 이 순간도 Antares는 불타고 있어요.
                    """),
                StoryPage(title: "당신의 별", content: """
                    10월 24일부터 11월 22일 사이에 태어난 당신.

                    전갈자리는 강렬한 별이에요. 붉게 타오르고, 깊이 느끼고, 한번 정한 건 끝까지 가는 별이죠.

                    Antares가 불타듯, 당신 안에도 그런 열정이 있을 거예요. 조용하지만 뜨겁게.

                    오늘 밤 남쪽 하늘에서 붉게 빛나는 별을 찾으면, 그게 당신의 심장이에요.
                    """)
            ]

        case .sagittarius:
            return [
                StoryPage(title: "탄생", content: """
                    궁수자리는 켄타우로스 케이론이에요.

                    반은 인간, 반은 말인 켄타우로스 중에서 케이론은 달랐어요. 거칠고 야만적인 다른 켄타우로스와 달리, 케이론은 지혜롭고 온화했죠. 아킬레우스, 아스클레피오스를 가르친 위대한 스승이었어요.

                    어느 날 헤라클레스의 독 묻은 화살이 실수로 케이론을 맞혔어요. 불멸의 몸이었기에 죽지도 못하고 고통만 계속되었죠.

                    케이론은 자신의 불멸을 프로메테우스에게 넘기고 편히 죽기를 택했어요.
                    """),
                StoryPage(title: "은하수의 중심", content: """
                    궁수자리의 화살은 전갈자리 방향을 가리키고 있어요.

                    그리고 그 방향에 우리 은하의 중심이 있어요. 여름 밤 궁수자리 근처의 은하수가 가장 밝고 넓게 보이는 건 그 때문이에요.

                    주전자 모양의 별 무리가 궁수자리의 중심이에요. 주전자 뚜껑에서 피어오르는 것처럼 보이는 희뿌연 빛이 은하수죠.

                    여름 밤 맑은 하늘에서 궁수자리를 찾으면, 우리 은하의 심장을 볼 수 있어요.
                    """),
                StoryPage(title: "Kaus Australis — 활의 남쪽", content: """
                    궁수자리에서 가장 밝은 별, Kaus Australis.

                    아랍어로 '활의 남쪽 끝'을 뜻해요. 지구에서 약 143광년 거리에 있고, 우리 태양보다 약 375배 밝은 별이에요.

                    케이론이 당긴 활의 화살이 가리키는 끝, 그 방향에 은하의 중심이 있어요.

                    수천 년 전 케이론이 화살을 당겼을 때, 그는 우리 은하의 심장을 겨누고 있었던 걸까요.
                    """),
                StoryPage(title: "당신의 별", content: """
                    11월 23일부터 12월 21일 사이에 태어난 당신.

                    궁수자리는 자유로운 별이에요. 화살은 언제나 앞을 향하고, 지평선 너머를 꿈꾸죠.

                    케이론이 가르침을 택했듯, 당신 안에도 나누고 싶은 것들이 있을 거예요.

                    오늘 밤 화살이 가리키는 방향으로 눈을 돌려보세요. 은하수의 중심이 바로 거기 있어요.
                    """)
            ]

        case .capricorn:
            return [
                StoryPage(title: "탄생", content: """
                    목신 판이 티폰을 피해 달아나던 날이었어요.

                    나일강 가에 있던 신들은 모두 동물로 변해 도망쳤죠. 판은 물고기로 변하려 했지만, 놀란 마음에 반만 변해버렸어요. 위는 염소, 아래는 물고기인 이상한 모습으로.

                    그 우스꽝스러운 모습을 제우스가 보고 웃으며 하늘에 올려줬어요.

                    완벽하지 않아도 괜찮다는 걸 보여주는 별자리로.
                    """),
                StoryPage(title: "겨울 하늘의 조용한 별", content: """
                    염소자리는 밤하늘에서 그리 밝지 않은 별자리예요.

                    화려한 오리온도, 붉은 전갈도 없죠. 하지만 고대부터 중요한 별자리였어요. 태양이 염소자리에 들어오는 날이 동지 — 일 년 중 밤이 가장 긴 날이었거든요.

                    지금은 세차운동으로 동지점이 이동했지만, 남회귀선의 영어 이름은 아직도 'Tropic of Capricorn — 염소자리의 선'이에요.

                    조용하지만, 제자리를 지키는 별자리.
                    """),
                StoryPage(title: "Deneb Algedi — 염소의 꼬리", content: """
                    염소자리에서 가장 밝은 별, Deneb Algedi.

                    아랍어로 '염소의 꼬리'를 뜻해요. 지구에서 약 39광년 거리에 있는 비교적 가까운 별이에요.

                    Deneb Algedi는 식쌍성이에요. 두 별이 서로를 가리면서 공전하기 때문에, 밝기가 주기적으로 변해요. 24시간마다 조금씩 어두워졌다 밝아졌다 하는 별.

                    겉으로는 하나처럼 보이지만, 사실 둘이 함께인 별. 염소자리답게, 겉과 속이 다른 별이에요.
                    """),
                StoryPage(title: "당신의 별", content: """
                    12월 22일부터 1월 19일 사이에 태어난 당신.

                    염소자리는 꾸준한 별이에요. 높은 산을 오르는 염소처럼, 천천히 하지만 멈추지 않죠.

                    완벽하지 않아도 앞으로 나아가는 것. 판이 반쪽짜리 변신으로도 도망쳤던 것처럼, 준비가 안 됐어도 일단 시작하는 용기.

                    그게 당신의 별이 가르쳐주는 것일 거예요.
                    """)
            ]

        case .aquarius:
            return [
                StoryPage(title: "탄생", content: """
                    물병자리는 가니메데의 이야기예요.

                    트로이의 왕자 가니메데는 세상에서 가장 아름다운 소년이었어요. 제우스는 독수리로 변해 그를 올림포스로 데려갔죠.

                    가니메데는 신들에게 신주를 따르는 역할을 맡았어요. 황금 물병을 들고, 불멸의 신들에게 영원히 시중을 드는.

                    어떤 이야기는 그가 행복했다고 해요. 별이 되어 영원히 하늘에서 물을 붓는 가니메데.
                    """),
                StoryPage(title: "독수리와 소년", content: """
                    가니메데를 데려간 독수리는 지금도 하늘에 있어요.

                    독수리자리 — 여름 밤하늘의 밝은 별 알타이르가 그 눈이에요. 물병자리 근처에서 지금도 날고 있죠.

                    가니메데가 올림포스에 올라가기 전, 그의 아버지 트로스 왕은 슬피 울었어요. 제우스는 미안한 마음에 황금빛 포도나무와 불사의 말 두 마리를 선물로 보냈다고 해요.

                    그래도 아버지는 그리웠겠죠. 하늘에서 물을 붓는 아들을 올려다보며.
                    """),
                StoryPage(title: "Sadalsuud — 가장 운 좋은 별", content: """
                    물병자리에서 가장 밝은 별, Sadalsuud.

                    아랍어로 '모든 것 중 가장 운이 좋은'이라는 뜻이에요. 봄의 시작을 알리며 지평선 위로 떠올랐기 때문에 붙은 이름이죠. 봄비를 가져오는 별.

                    지구에서 약 610광년 거리에 있는 초거성이에요. 우리 태양보다 2,200배 밝은 별.

                    봄을 알리고, 비를 가져오고, 운을 붓는 별. 가니메데가 물을 붓듯.
                    """),
                StoryPage(title: "당신의 별", content: """
                    1월 20일부터 2월 18일 사이에 태어난 당신.

                    물병자리는 나누는 별이에요. 물을 붓고, 흘려보내고, 채우기보다 비우는 별이죠.

                    당신 안에도 그런 마음이 있을 거예요. 가진 것을 나누고 싶은, 세상이 조금 더 나아지길 바라는.

                    오늘 밤 가니메데가 하늘에서 물을 붓고 있어요. 그 물이 당신에게 닿길 바라며.
                    """)
            ]

        case .pisces:
            return [
                StoryPage(title: "탄생", content: """
                    티폰이 올림포스를 공격하던 날, 아프로디테와 에로스는 유프라테스 강가에 있었어요.

                    둘은 물고기로 변해 강에 뛰어들었고, 서로를 잃지 않으려 끈으로 묶었어요.

                    그 끈이 지금도 물고기자리에서 보여요. 두 물고기가 반대 방향을 향하지만, 가운데 끈으로 연결된 모습.

                    아프로디테는 그 순간을 하늘에 새겼어요. 서로를 놓지 않았던 그 마음을 기억하기 위해.
                    """),
                StoryPage(title: "봄의 문", content: """
                    물고기자리는 황도의 마지막 별자리예요.

                    양자리가 시작이라면, 물고기자리는 끝이자 다시 시작의 문이에요. 태양이 물고기자리를 지나면 봄이 시작되는 양자리로 들어가죠.

                    춘분점 — 봄이 시작되는 그 점이 지금 물고기자리 안에 있어요. 세차운동으로 옮겨온 거예요.

                    끝과 시작이 만나는 곳. 물고기자리는 그 문턱을 지키고 있어요.
                    """),
                StoryPage(title: "두 물고기의 비밀", content: """
                    물고기자리의 두 물고기는 서로 다른 방향을 보고 있어요.

                    하나는 북쪽을, 하나는 서쪽을. 반대 방향을 바라보지만 끈으로 연결되어 있죠.

                    천문학적으로 물고기자리는 매우 희미한 별자리예요. 눈에 잘 띄지 않아요. 하지만 그 안에 춘분점이 있고, 황도가 지나가죠.

                    보이지 않아도 중요한 것들이 있어요. 물고기자리처럼.
                    """),
                StoryPage(title: "당신의 별", content: """
                    2월 19일부터 3월 20일 사이에 태어난 당신.

                    물고기자리는 연결의 별이에요. 반대 방향을 바라보면서도 끊어지지 않는 끈.

                    당신 안에도 그런 유대가 있을 거예요. 멀어져도 연결되어 있는 사람들, 놓고 싶지 않은 것들.

                    오늘 밤 두 물고기가 하늘을 헤엄치고 있어요. 서로를 향한 끈을 쥔 채로.
                    """)
            ]
        }
    }
}

extension Constellation {
    var relations: [StarRelation] {
        switch self {
        case .aries:
            return [
                StarRelation(type: "하늘에서 가장 가까운", constellation: "황소자리", description: "바로 옆에서 함께 봄 하늘을 밝혀요", icon: "star.fill"),
                StarRelation(type: "신화적 연결", constellation: "오리온자리", description: "황금 양털을 찾아 떠난 이아손의 이야기로 연결돼요", icon: "link"),
                StarRelation(type: "계절 동반자", constellation: "쌍둥이자리", description: "봄 하늘에서 함께 빛나는 별이에요", icon: "moon.stars.fill"),
                StarRelation(type: "대척점 별자리", constellation: "천칭자리", description: "하늘 정반대편에서 균형을 이뤄요", icon: "arrow.left.arrow.right")
            ]
        case .taurus:
            return [
                StarRelation(type: "하늘에서 가장 가까운", constellation: "양자리", description: "봄 하늘에서 나란히 빛나요", icon: "star.fill"),
                StarRelation(type: "신화적 연결", constellation: "오리온자리", description: "오리온이 플레이아데스를 쫓는 이야기로 연결돼요", icon: "link"),
                StarRelation(type: "계절 동반자", constellation: "쌍둥이자리", description: "겨울 밤하늘을 함께 수놓아요", icon: "moon.stars.fill"),
                StarRelation(type: "대척점 별자리", constellation: "전갈자리", description: "하늘 반대편에서 마주보고 있어요", icon: "arrow.left.arrow.right")
            ]
        case .gemini:
            return [
                StarRelation(type: "하늘에서 가장 가까운", constellation: "황소자리", description: "겨울 하늘에서 이웃해 있어요", icon: "star.fill"),
                StarRelation(type: "신화적 연결", constellation: "오리온자리", description: "겨울 하늘의 삼각형을 함께 이뤄요", icon: "link"),
                StarRelation(type: "계절 동반자", constellation: "게자리", description: "봄 하늘로 이어지는 다리 역할을 해요", icon: "moon.stars.fill"),
                StarRelation(type: "대척점 별자리", constellation: "사수자리", description: "하늘 반대편 은하수 중심 근처에 있어요", icon: "arrow.left.arrow.right")
            ]
        case .cancer:
            return [
                StarRelation(type: "하늘에서 가장 가까운", constellation: "쌍둥이자리", description: "겨울과 봄 사이를 함께 지켜요", icon: "star.fill"),
                StarRelation(type: "신화적 연결", constellation: "히드라자리", description: "헤라클레스 신화로 연결된 별이에요", icon: "link"),
                StarRelation(type: "계절 동반자", constellation: "사자자리", description: "봄 하늘의 동반자예요", icon: "moon.stars.fill"),
                StarRelation(type: "대척점 별자리", constellation: "염소자리", description: "하늘 반대편에서 서로를 바라봐요", icon: "arrow.left.arrow.right")
            ]
        case .leo:
            return [
                StarRelation(type: "하늘에서 가장 가까운", constellation: "게자리", description: "봄 하늘에서 이웃해 있어요", icon: "star.fill"),
                StarRelation(type: "신화적 연결", constellation: "헤라클레스자리", description: "헤라클레스의 첫 번째 과업으로 연결돼요", icon: "link"),
                StarRelation(type: "계절 동반자", constellation: "처녀자리", description: "봄의 대삼각형을 함께 이뤄요", icon: "moon.stars.fill"),
                StarRelation(type: "대척점 별자리", constellation: "물병자리", description: "하늘 반대편에서 균형을 이뤄요", icon: "arrow.left.arrow.right")
            ]
        case .virgo:
            return [
                StarRelation(type: "하늘에서 가장 가까운", constellation: "사자자리", description: "봄 하늘에서 나란히 빛나요", icon: "star.fill"),
                StarRelation(type: "신화적 연결", constellation: "천칭자리", description: "아스트라이아의 저울로 연결돼요", icon: "link"),
                StarRelation(type: "계절 동반자", constellation: "천칭자리", description: "봄에서 여름으로 이어지는 동반자예요", icon: "moon.stars.fill"),
                StarRelation(type: "대척점 별자리", constellation: "물고기자리", description: "하늘 반대편에서 마주보고 있어요", icon: "arrow.left.arrow.right")
            ]
        case .libra:
            return [
                StarRelation(type: "하늘에서 가장 가까운", constellation: "처녀자리", description: "봄과 여름 사이를 함께 지켜요", icon: "star.fill"),
                StarRelation(type: "신화적 연결", constellation: "처녀자리", description: "아스트라이아 여신의 저울로 연결돼요", icon: "link"),
                StarRelation(type: "계절 동반자", constellation: "전갈자리", description: "여름 하늘의 동반자예요", icon: "moon.stars.fill"),
                StarRelation(type: "대척점 별자리", constellation: "양자리", description: "하늘 반대편에서 균형을 이뤄요", icon: "arrow.left.arrow.right")
            ]
        case .scorpio:
            return [
                StarRelation(type: "하늘에서 가장 가까운", constellation: "천칭자리", description: "여름 하늘에서 이웃해 있어요", icon: "star.fill"),
                StarRelation(type: "영원한 적", constellation: "오리온자리", description: "영원히 만나지 못하는 숙명의 별이에요", icon: "bolt.fill"),
                StarRelation(type: "계절 동반자", constellation: "사수자리", description: "여름 밤하늘 은하수 근처에서 함께 빛나요", icon: "moon.stars.fill"),
                StarRelation(type: "대척점 별자리", constellation: "황소자리", description: "하늘 반대편에서 오리온과 함께 있어요", icon: "arrow.left.arrow.right")
            ]
        case .sagittarius:
            return [
                StarRelation(type: "하늘에서 가장 가까운", constellation: "전갈자리", description: "여름 밤하늘 은하수를 함께 지켜요", icon: "star.fill"),
                StarRelation(type: "신화적 연결", constellation: "켄타우루스자리", description: "같은 켄타우로스 족으로 연결돼요", icon: "link"),
                StarRelation(type: "은하수 동반자", constellation: "독수리자리", description: "은하수 위에서 함께 빛나요", icon: "moon.stars.fill"),
                StarRelation(type: "대척점 별자리", constellation: "쌍둥이자리", description: "하늘 반대편에서 마주보고 있어요", icon: "arrow.left.arrow.right")
            ]
        case .capricorn:
            return [
                StarRelation(type: "하늘에서 가장 가까운", constellation: "사수자리", description: "여름과 가을 사이를 함께 지켜요", icon: "star.fill"),
                StarRelation(type: "신화적 연결", constellation: "물병자리", description: "올림포스 신들의 이야기로 연결돼요", icon: "link"),
                StarRelation(type: "계절 동반자", constellation: "물병자리", description: "가을 밤하늘의 동반자예요", icon: "moon.stars.fill"),
                StarRelation(type: "대척점 별자리", constellation: "게자리", description: "하늘 반대편에서 균형을 이뤄요", icon: "arrow.left.arrow.right")
            ]
        case .aquarius:
            return [
                StarRelation(type: "하늘에서 가장 가까운", constellation: "염소자리", description: "가을 하늘에서 이웃해 있어요", icon: "star.fill"),
                StarRelation(type: "신화적 연결", constellation: "독수리자리", description: "가니메데를 데려간 독수리로 연결돼요", icon: "link"),
                StarRelation(type: "계절 동반자", constellation: "물고기자리", description: "가을 밤하늘을 함께 수놓아요", icon: "moon.stars.fill"),
                StarRelation(type: "대척점 별자리", constellation: "사자자리", description: "하늘 반대편에서 마주보고 있어요", icon: "arrow.left.arrow.right")
            ]
        case .pisces:
            return [
                StarRelation(type: "하늘에서 가장 가까운", constellation: "물병자리", description: "가을 하늘에서 나란히 빛나요", icon: "star.fill"),
                StarRelation(type: "신화적 연결", constellation: "물병자리", description: "아프로디테와 에로스의 이야기로 연결돼요", icon: "link"),
                StarRelation(type: "계절 동반자", constellation: "양자리", description: "봄으로 이어지는 겨울 밤하늘의 동반자예요", icon: "moon.stars.fill"),
                StarRelation(type: "대척점 별자리", constellation: "처녀자리", description: "하늘 반대편에서 균형을 이뤄요", icon: "arrow.left.arrow.right")
            ]
        }
    }
}
