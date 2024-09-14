//
//  UserViewModel.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 22/08/24.
//

import SwiftUI
import Combine

class PostViewModel: ObservableObject, Identifiable, Equatable {
    static func == (lhs: PostViewModel, rhs: PostViewModel) -> Bool {
        //
        return true
    }
    
    @Published var posts: [Post] = []
    @Published var errorMessage: String?
    
    func fetchPosts() async {
        do {
            let posts = try await API.searchPosts()
            DispatchQueue.main.async {
                self.posts = posts
            }
        } catch {
//            DispatchQueue.main.async {
//                self.errorMessage = error.localizedDescription
//            }
            print(error)
        }
    }
    
    
    func check(data: Data?, response: URLResponse) throws {
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
    
    func createPost(text: String, with token: String) async throws -> Post {
        let url = API.baseURL.appendingPathComponent("posts")

        let create = Post.Create(text: text)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = text.data(using: .utf8)
        request.allHTTPHeaderFields = [
            "Content-Type": "text/plain"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        let post = try JSONDecoder().decode(Post.self, from: data)
        
        return post
    }
    
    func likePost(postId: UUID, with token: String) async throws {
        let url = API.baseURL.appending(path: "likes/\(postId)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
            
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        print("Like")
    }
    
    func dislikePost(postId: UUID, with token: String) async throws {
        let url = API.baseURL.appending(path: "likes/\(postId)")

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
            
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        print("Dislike")
    }

    func postLikingUsers(postId: UUID, with token: String) async throws -> [User] {
        let url = API.baseURL.appending(path: "likes/liking_users/\(postId)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
            
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        let users = try JSONDecoder().decode([User].self, from: data)
        
        for user in users {
            print("\(user.name)\n")
        }
        
        return users
    }
    
    func reportPost(with token: String, postID: UUID, reason: String) async throws {
        let url = API.baseURL.appendingPathComponent("reports/\(postID)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(reason)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        _ = try await URLSession.shared.data(for: request)
        print("Post \(postID) reportado")
    }
}
