//
//  API.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 22/08/24.
//

import Foundation

enum API {
    
    static func check(data: Data?, response: URLResponse) throws {
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200..<300:
                print("😸 Sucesso! \(response.statusCode)")
            default:
                print("🙀 Erro \(response.statusCode)")
                throw APIError.apiError(code: response.statusCode, body: data)
            }
        }
    }
    
    static func searchUsers(on baseURL: URL) async throws -> [User] {
        let url = baseURL.appending(path: "users")
        let (data, response) = try await URLSession.shared.data(from: url)
        
        try check(data: data, response: response)
        // DECODE! Bytes -> [User]
        let users = try JSONDecoder().decode([User].self, from: data)
        return users
    }
    
    static func createUser(on baseURL: URL, name: String) async throws -> String {
        let url = baseURL.appending(path: "users")
        
        let create = User.Create(name: name, username: "lorem-ipsum", password: "12345")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(create)
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        let session = try JSONDecoder().decode(Session.self, from: data)
        
        return session.token
    }
    
}
