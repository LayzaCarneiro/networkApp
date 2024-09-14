//
//  LoginViewModel.swift
//  NetworkApp
//
//  Created by Leticia França on 23/08/24.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var user: User?
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var avatar: String = ""
    
    @Published var tokenLogin: String?
    
    let baseURL = URL(string: "http://127.0.0.1:8080")!
    
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
    
    func login() async throws -> String {
        let url = API.baseURL.appending(path: "users/login")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let username = username
        let password = password
        
        let auth = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
        
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        let session = try JSONDecoder().decode(Session.self, from: data)
        
        self.user = session.user
        
        let token = session.token
        
        print("token criado: \(token)")
            
        self.tokenLogin = token
        
        return session.token
    }
    
    func me(with token: String) async throws -> User {
        let url = API.baseURL.appending(path: "users/me")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try check(data: data, response: response)
        
        let user = try JSONDecoder().decode(User.self, from: data)
        
        print("usuario \(user)")
        
        return user
        
    }
    
    func logout(with token: String) async throws {
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
    
}
