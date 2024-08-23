//
//  ContentView.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 22/08/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()
    @State var name: String = ""
    
    var body: some View {
        VStack {
            
            if viewModel.users.isEmpty {
                Text("Nenhum usuário encontrado.")
                    .padding()
            } else {
                List(viewModel.users, id: \.id) { user in
                    Text(user.name)
                }
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text("Erro: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            
        }
        .onAppear {
            Task {
                await viewModel.fetchUsers()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
