//
//  UserViewModel.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 22/08/24.
//

import SwiftUI
import Combine
import UIKit

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var errorMessage: String?
    
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var password: String = ""

    let baseURL = URL(string: "http://127.0.0.1:8080")!

    func fetchUsers() async {
        do {
            let users = try await API.searchUsers(on: baseURL)
            DispatchQueue.main.async {
                self.users = users
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
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
    
    func createUser(on baseURL: URL) async throws -> String {
        let url = baseURL.appending(path: "users")
        
        let create = User.Create(name: name, username: username, password: password)
        
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
    
    func login(on baseURL: URL) async throws -> String {
        let url = baseURL.appending(path: "users/login")
        
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

//    func updateAvatar(on baseURL: URL) async throws -> String {
//        Task {
//            do {
//                guard let image = UIImage(named: "defaultAvatar") else {
//                    throw URLError(.fileDoesNotExist)
//                }
//                
//                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//                    throw URLError(.badURL)
//                }
//                
//                let base64String = imageData.base64EncodedString()
//                
//                let requestBody: [String: String] = [
//                    "id": user.id.uuidString,
//                    "username": user.username,
//                    "name": user.name,
//                    "avatar": base64String
//                ]
//                
//                let token = try await API.updateAvatar(on: baseURL, requestBody: requestBody)
//                
//                DispatchQueue.main.async {
//                    print("Avatar atualizado com sucesso! Token: \(token)")
//                }
//                
//            } catch {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Erro ao atualizar o avatar: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
}
