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
    
    // 공통 리퀘스트 설정 함수
    private func makeRequest(url: URL, method: String = "GET") -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Yunseul-App", forHTTPHeaderField: "User-Agent")
        return request
    }
    
    // MARK: - 카운트 읽기
    func fetchCount() async -> Int {
        guard let url = URL(string: "https://api.github.com/gists/\(gistID)") else { return 0 }
        
        let request = makeRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // 응답 코드 확인 (200이 아니면 에러)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("[Gist] Fetch 에러 코드: \(httpResponse.statusCode)")
                return 0
            }
            
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let files = json["files"] as? [String: Any],
                  let file = files[fileName] as? [String: Any],
                  let content = file["content"] as? String,
                  let contentData = content.data(using: .utf8),
                  let countJson = try JSONSerialization.jsonObject(with: contentData) as? [String: Int],
                  let count = countJson["count"] else {
                print("[Gist] JSON 파싱 실패")
                return 0
            }
            
            return count
        } catch {
            print("[Gist] 네트워크 에러: \(error.localizedDescription)")
            return 0
        }
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
        
        do {
            let data = try JSONSerialization.data(withJSONObject: payload)
            var request = makeRequest(url: url, method: "PATCH")
            request.httpBody = data
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("[Gist] 카운트 업데이트 성공: \(newCount)")
            } else {
                let code = (response as? HTTPURLResponse)?.statusCode ?? 0
                print("[Gist] 업데이트 실패 코드: \(code)")
            }
            
        } catch {
            print("[Gist] 업데이트 중 에러: \(error.localizedDescription)")
        }
        
        return newCount
    }
}
