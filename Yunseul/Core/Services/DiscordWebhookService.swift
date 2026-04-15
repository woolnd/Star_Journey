//
//  DiscordWebhookService.swift
//  Yunseul
//
//  Created by wodnd on 4/15/26.
//

import Foundation
import CoreLocation

final class DiscordWebhookService {
    
    static let shared = DiscordWebhookService()
    private init() {}
    
    private let webhookURL = Secrets.discordWebhookURL
    
    func sendNewUserRegistration(
        nickname: String,
        birthDate: Date,
        constellation: Constellation
    ) async {
        let count = await GistService.shared.incrementCount()
        let countryEmoji = await fetchCountryEmoji()
        
        guard let url = URL(string: webhookURL) else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let birthDateString = formatter.string(from: birthDate)
        
        let payload: [String: Any] = [
            "embeds": [
                [
                    "title": "✦ \(count)번째 별빛이 등록됐어요 \(countryEmoji)",
                    "color": 0x4A7DE0,
                    "fields": [
                        ["name": "닉네임", "value": nickname, "inline": true],
                        ["name": "생일", "value": birthDateString, "inline": true],
                        ["name": "수호성", "value": "\(constellation.rawValue) (\(constellation.latinName))", "inline": true]
                    ],
                    "footer": ["text": "윤슬 Yunseul · 누적 \(count)명"],
                    "timestamp": ISO8601DateFormatter().string(from: Date())
                ]
            ]
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: payload) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                print("✦ [Discord] 웹훅 전송 - 상태코드: \(httpResponse.statusCode)")
            }
        } catch {
            print("🔴 [Discord] 웹훅 전송 실패: \(error)")
        }
    }
    
    // MARK: - 국가 이모지 가져오기
    private func fetchCountryEmoji() async -> String {
        let locale = Locale.current
        guard let regionCode = locale.region?.identifier else { return "🌍 기타" }
        
        switch regionCode {
        case "KR": return "🇰🇷 한국"
        case "JP": return "🇯🇵 일본"
        case "US": return "🇺🇸 미국"
        case "CN": return "🇨🇳 중국"
        case "TW": return "🇹🇼 대만"
        case "GB": return "🇬🇧 영국"
        case "DE": return "🇩🇪 독일"
        case "FR": return "🇫🇷 프랑스"
        case "AU": return "🇦🇺 호주"
        case "CA": return "🇨🇦 캐나다"
        case "SG": return "🇸🇬 싱가포르"
        case "HK": return "🇭🇰 홍콩"
        case "TH": return "🇹🇭 태국"
        case "VN": return "🇻🇳 베트남"
        case "IN": return "🇮🇳 인도"
        default:
            let emoji = regionCode.unicodeScalars.reduce("") {
                $0 + String(UnicodeScalar(127397 + $1.value)!)
            }
            return "\(emoji) 기타 (\(regionCode))"
        }
    }
}
