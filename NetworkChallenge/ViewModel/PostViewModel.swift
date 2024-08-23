//
//  UserViewModel.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 22/08/24.
//

import SwiftUI
import Combine

class PostViewModel: ObservableObject {
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
     
    func createPost(on baseURL: URL) async throws -> String {
        let url = baseURL.appending(path: "posts")
        let userIDString = "123"
        let userID = UUID(uuidString: userIDString)

        let create = Post.Create(text: "TESTEAAAAEEEE", media: "", likeCount: 2, createdAt: Date.now, updatedAt: Date.now, userID: userID)

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
