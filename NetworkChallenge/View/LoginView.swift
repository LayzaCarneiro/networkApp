//
//  LoginView.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 27/08/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var viewModelLogin = LoginViewModel()

    @State private var navFeed = false

    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.backgroundOffWhite.ignoresSafeArea()
                
                VStack(spacing: 50) {
                    
                    ZStack {
                        Image("loginTicket")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 320)
                            .clipped()
                        
                        
                        VStack(spacing: 25) {
                            ZStack {
                                Image("textfield")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 190)
                                    .clipped()
                                
                                TextField("Usuário", text: $viewModelLogin.username)
                                    .padding(.leading, 65)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            }
                            
                            ZStack {
                                Image("textfield")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 190)
                                    .clipped()
                                
                                TextField("Senha", text: $viewModelLogin.password)
                                    .padding(.leading, 65)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                
                                
                            }
                            
                        }
                        .padding(.trailing, 80)
                        
                    }
                    
                    Button {
                        Task {
                            do {
                                try await viewModelLogin.login(on: viewModelLogin.baseURL)
                                print("fez login")
                                navFeed = true
                            } catch {
                                print("Login error: \(error)")
                            }
                        }
                    } label: {
                        ZStack {
                            Image("botaoLogin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140)
                            
                            Text("Entrar")
                                .font(.title)
                        }
                    }
                }
                .navigationDestination(isPresented: $navFeed) {
                    LikesView(userToken: viewModelLogin.tokenLogin ?? "", user: viewModelLogin.user)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
