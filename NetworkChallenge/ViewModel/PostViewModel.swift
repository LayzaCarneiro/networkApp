//
//  UserViewModel.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 22/08/24.
//

import SwiftUI
import Combine

class PostViewModel: ObservableObject, Identifiable {
    @Published var posts: [Post] = []
    @Published var errorMessage: String?
    
    let baseURL = URL(string: "http://127.0.0.1:8080")!
    
    func fetchPosts() async {
        do {
            let posts = try await API.searchPosts(on: baseURL)
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
    
//    func deletar(on baseURL: URL, postID: UUID) async throws {
//        let url = baseURL.appending(path: "posts/\(postID.uuidString)")
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//        request.allHTTPHeaderFields = [
//            "Authorization": "Bearer \(viewModelLogin.tokenLogin ?? "")"
//        ]
//        let (data, response) = try await URLSession.shared.data(for: request)
//    }
//
//    func deletePost(_ indexSet: IndexSet) {
//        for index in indexSet {
//            let post = posts[index]
//            Task {
//                do {
//                    try await deletar(on: baseURL, postID: post.id)
//                    posts.remove(at: index)
//                } catch {
//                    errorMessage = "erro de deletar: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
    
    func createPost(on baseURL: URL, text: String, with token: String) async throws -> Post {
        let url = baseURL.appendingPathComponent("posts")

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
    
    func likePost(on baseURL: URL, postId: UUID, with token: String) async throws {
        let url = baseURL.appending(path: "likes/\(postId)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
            
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        print("Like")
    }
    
    func dislikePost(on baseURL: URL, postId: UUID, with token: String) async throws {
        let url = baseURL.appending(path: "likes/\(postId)")

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
            
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        print("Dislike")
    }

    func postLikingUsers(on baseURL: URL, postId: UUID, with token: String) async throws -> [User] {
        let url = baseURL.appending(path: "likes/liking_users/\(postId)")

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
}
