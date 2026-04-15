//
//  GistService.swift
//  Yunseul
//
//  Created by wodnd on 4/15/26.
//

import Foundation

final class GistService {
    
    static let shared = GistService()
    private init() {}
    
    private let token = Secrets.githubToken
    private let gistID = "5fd6fe6f4977fb3aaec3019d10287428"
    private let fileName = "yunseul_count.json"
    
    // MARK: - 카운트 읽기
    func fetchCount() async -> Int {
        guard let url = URL(string: "https://api.github.com/gists/\(gistID)") else { return 0 }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        guard let (data, _) = try? await URLSession.shared.data(for: request),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let files = json["files"] as? [String: Any],
              let file = files[fileName] as? [String: Any],
              let content = file["content"] as? String,
              let contentData = content.data(using: .utf8),
              let countJson = try? JSONSerialization.jsonObject(with: contentData) as? [String: Int],
              let count = countJson["count"] else { return 0 }
        
        return count
    }
    
    // MARK: - 카운트 +1 업데이트
    func incrementCount() async -> Int {
        let current = await fetchCount()
        let newCount = current + 1
        
        guard let url = URL(string: "https://api.github.com/gists/\(gistID)") else { return newCount }
        
        let content = "{\"count\": \(newCount)}"
        let payload: [String: Any] = [
            "files": [fileName: ["content": content]]
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: payload) else { return newCount }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        _ = try? await URLSession.shared.data(for: request)
        print("✦ [Gist] 카운트 업데이트: \(newCount)")
        return newCount
    }
}
