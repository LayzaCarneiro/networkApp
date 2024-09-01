//
//  LoginView.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 27/08/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var viewModelLogin = LoginViewModel()
    @ObservedObject var viewModelUser = UserViewModel()

    @State private var navFeed = false
    
    @State private var isPasswordValid: Bool = true
    @State private var isUsernameValid: Bool = true
    @State private var showErrorMessages: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.backgroundOffWhite.ignoresSafeArea()
                
                VStack {
                                        
                    ZStack {
                        Image("loginTicket")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 320)
                            .clipped()
                        
                        
                        VStack {
                            if (showErrorMessages && !isUsernameValid) {
                                LoginTicket(placeholder: "Usuário", textfield: "wrongTextfield", field: $viewModelLogin.username)
                                
                                if showErrorMessages && !isUsernameValid {
                                    Text("O usuário está incorreto")
                                        .font(.caption1)
                                        .foregroundColor(.red)
                                }
                                
                            } else {
                                LoginTicket(placeholder: "Usuário", field: $viewModelLogin.username)
                            }
                            
                            if (showErrorMessages && !isPasswordValid) {
                                LoginTicket(placeholder: "Senha", textfield: "wrongTextfield", field: $viewModelLogin.password, isSecure: true)
                                    .padding(.top, 5)
                                
                                if showErrorMessages && !isPasswordValid {
                                    Text("A senha está incorreta")
                                        .font(.caption1)
                                        .foregroundColor(.red)
                                        
                                }
                                
                            } else {
                                LoginTicket(placeholder: "Senha", field: $viewModelLogin.password, isSecure: true)
                                    .padding(.top, 20)

                            }
                            
                        }
                        .padding(.trailing, 80)
                    }
                    
                    Button {
                        
                        Task {
                            do {
                                try await viewModelLogin.login(on: viewModelLogin.baseURL)
                                navFeed = true
                                
                                isUsernameValid = true
                                isPasswordValid = true
                                showErrorMessages = false
                                
                            } catch {
                                isUsernameValid = false
                                isPasswordValid = false
                                showErrorMessages = true
                            }
                        }
                       
                    } label: {
                        ZStack {
                            Image("botaoLogin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140)
                            
                            Text("Entrar")
                                .font(.title2)
                                .foregroundStyle(.backgroundOffWhite)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.top, 35)
                    
                    NavigationLink(destination: CreateUserView()) {
                        Text("Cadastro")
                            .font(.title3, weight: .regular)
                            .underline(true, color: .brownPixel)
                            .foregroundStyle(.brownPixel)
                            .padding(.top, 15)
                    }
                }
                .navigationDestination(isPresented: $navFeed) {
                    HomeView(viewModelLogin: viewModelLogin)
//
                }
            }
            .onAppear {
                Task {
                    await viewModelUser.fetchUsers()
                }
            }
        }
        .accentColor(.brownPixel)
    }
}

#Preview {
    LoginView()
}
