//
//  LoginView.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 27/08/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModelLogin = LoginViewModel()

    @State private var navFeed = false
    
    @State private var isPasswordValid: Bool = true
    @State private var isUsernameValid: Bool = true
    @State private var showErrorMessages: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.backgroundOffWhite.ignoresSafeArea()
                
                VStack {
                    
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .padding(.top, -70)

                    
                    ZStack {
                        Image("loginTicket")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 320)
                            .clipped()
                        
                        
                        VStack {
                            if (showErrorMessages && !isUsernameValid) {
                                LoginTicket(placeholder: "Usuário", textfield: "wrongTextfield", field: $viewModelLogin.username)
                                
                                Text("O usuário está incorreto")
                                    .font(.caption1)
                                    .foregroundColor(.red)
                                
                            } else {
                                LoginTicket(placeholder: "Usuário", field: $viewModelLogin.username)
                            }
                            
                            if (showErrorMessages && !isPasswordValid) {
                                LoginTicket(placeholder: "Senha", textfield: "wrongTextfield", field: $viewModelLogin.password, isSecure: true)
                                    .padding(.top, 5)
                                
                                Text("A senha está incorreta")
                                    .font(.caption1)
                                    .foregroundColor(.red)
                                        
                            } else {
                                LoginTicket(placeholder: "Senha", field: $viewModelLogin.password, isSecure: true)
                                    .padding(.top, 20)

                            }
                            
                        }
                        .padding(.trailing, 80)
                    }
                    .padding(.bottom, 15)
                    
                    Button {
                        
                        Task {
                            do {
                                try await viewModelLogin.login()
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
                                .foregroundColor(.backgroundOffWhite)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.top, 35)
                    
                    HStack(spacing: 0) {
                        
                        Text("Se não possui conta. ")
                            .font(.body, weight: .regular)
                            .foregroundStyle(.brownPixel)
                            .padding(.top, 15)
                        
                        NavigationLink(destination: CreateUserView()) {
                            Text("Se cadastre.")
                                .font(.body, weight: .regular)
                                .underline(true, color: .brownPixel)
                                .foregroundStyle(.brownPixel)
                                .padding(.top, 15)
                        }
                    }
                }
                .navigationDestination(isPresented: $navFeed) {
                    HomeView(viewModelLogin: viewModelLogin)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(.brownPixel)
    }
}

#Preview {
    LoginView()
}
