//
//  UserViewModel.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 22/08/24.
//

import SwiftUI
import Combine

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var errorMessage: String?
    
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

    func createUser(name: String) async {
        do {
            let _ = try await API.createUser(on: baseURL, name: name)
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }

}
