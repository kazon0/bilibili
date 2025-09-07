//
//  ApiService.swift
//  BiliBili
//
//  Created by 郑金坝 on 2025/9/6.
//


import Foundation

struct LoginResponse: Codable {
    let code: Int
    let msg: String
    let data: String?
}


class ApiService {
    static let shared = ApiService()
    private init() {}
    
    private let baseURL = "http://127.0.0.1:4523/m1/7076071-6797237-default"
    

    func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/login") else {
            print(" URL 无效")
            completion(.failure(NSError(domain: "ApiService", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL 无效"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "username": username,
            "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            if let jsonString = String(data: request.httpBody!, encoding: .utf8) {
                print(" 发送请求 Body:", jsonString)
            }
        } catch {
            print(" JSON 序列化失败:", error)
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(" 请求错误:", error)
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print(" HTTP 状态码:", httpResponse.statusCode)
            }

            guard let data = data else {
                print(" 返回数据为空")
                completion(.failure(NSError(domain: "ApiService", code: -2, userInfo: [NSLocalizedDescriptionKey: "返回数据为空"])))
                return
            }

            if let rawResponse = String(data: data, encoding: .utf8) {
                print(" 原始返回内容:", rawResponse)
            }

            do {
                let resp = try JSONDecoder().decode(LoginResponse.self, from: data)
                print(" 解析 JSON 成功: code=\(resp.code), msg=\(resp.msg), data=\(resp.data ?? "nil")")
                
                if resp.code == 200, let token = resp.data {
                    completion(.success(token))
                } else {
                    let errorInfo = NSError(
                        domain: "ApiService",
                        code: resp.code,
                        userInfo: [NSLocalizedDescriptionKey: resp.msg]
                    )
                    print(" API 返回错误:", resp.msg)
                    completion(.failure(errorInfo))
                }
            } catch {
                print(" JSON 解析失败:", error)
                completion(.failure(error))
            }
        }.resume()
    }

    func getVideosDecodable(page: Int = 1,
                            pageSize: Int = 20,
                            token: String? = nil,
                            completion: @escaping (Result<[Videos], Error>) -> Void) {
        
        var components = URLComponents(string: "\(baseURL)/user/videos")!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "pagesize", value: "\(pageSize)")
        ]
        
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = token {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: -1)))
                    return
                }
                
                // 打印原始 JSON 字符串
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("返回 JSON: \(jsonString)")
                }
                
                do {
                    let response = try JSONDecoder().decode(VideoResponses.self, from: data)
                    if response.code == 0 {
                        completion(.success(response.data))
                    } else {
                        completion(.failure(NSError(domain: response.msg, code: response.code)))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()

    }

}
