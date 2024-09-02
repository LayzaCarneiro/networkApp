//
//  API.swift
//
//
//  Created by Gabriela Bezerra on 20/08/24.
//

import Foundation

enum API {
    
//    static let baseURL: URL = URL(string: "http://10.45.53.186:8080")!
    static let baseURL: URL = URL(string: "http://127.0.0.1:8080")!

    
    static func searchPosts() async throws -> [Post] {
        let url = API.baseURL.appending(path: "posts")
        var components = URLComponents(string: url.absoluteString)!
        components.queryItems = [
            URLQueryItem(name: "expand", value: "user_id")
        ]
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        
        try check(data: data, response: response)
        let posts = try JSONDecoder().decode([Post].self, from: data)
        return posts
    }
    
    static func searchUsers() async throws -> [User] {
        let url = API.baseURL.appending(path: "users")
        let (data, response) = try await URLSession.shared.data(from: url)
        
        try check(data: data, response: response)
        // DECODE! Bytes -> [User]
        let users = try JSONDecoder().decode([User].self, from: data)
        return users
    }
    
    static func searchReports(postID: UUID) async throws -> [Report] {
        let url = API.baseURL.appending(path: "reports/\(postID.uuidString)")
        let (data, response) = try await URLSession.shared.data(from: url)
        
        try check(data: data, response: response)
        let reports = try JSONDecoder().decode([Report].self, from: data)
        return reports
    }
    
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
    
    static func createUser() async throws -> String {
        let url = API.baseURL.appending(path: "users")
        
        let create = User.Create(name: "Lorem Ipsum", username: "lorem-ipsum", password: "12345")
        
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
    
    static func login() async throws -> String {
        let url = API.baseURL.appending(path: "users/login")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let username = "lorem.ipsum"
        let password = "12345"
        
        let auth = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
        
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        let session = try JSONDecoder().decode(Session.self, from: data)
        
        return session.token
    }
    
    static func me(with token: String) async throws -> User {
        let url = API.baseURL.appending(path: "users/me")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        let user = try JSONDecoder().decode(User.self, from: data)
        return user
    }
    
    static func logout(with token: String) async throws {
        let url = API.baseURL.appending(path: "users/logout")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        let session = try JSONDecoder().decode(Session.self, from: data)
        
        print(session.token)
    }
    
    static func likePost(postId: UUID, with token: String) async throws {
        let url = API.baseURL.appending(path: "likes/\(postId)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
            
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        print("Like")
    }
    
    static func dislikePost(postId: UUID, with token: String) async throws {
        let url = API.baseURL.appending(path: "likes/\(postId)")

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
            
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        print("Dislike")
    }

    static func postLikingUsers(postId: UUID, with token: String) async throws -> [User] {
        let url = API.baseURL.appending(path: "likes/liking_users/\(postId)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
            
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        let users = try JSONDecoder().decode([User].self, from: data)
        return users
    }
    
}
