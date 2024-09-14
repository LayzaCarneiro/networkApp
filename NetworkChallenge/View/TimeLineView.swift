//
//  TimeLineView.swift
//  NetworkChallenge
//
//  Created by Raynara Coelho on 27/08/24.

import Foundation
import SwiftUI

struct TimeLineView: View {
    @State private var showingSheetPost = false
    @State private var showingSheetCharacter = false
    @StateObject var textCount = TextCount()
    
    @StateObject var viewModel = CharacterViewModel()
    @StateObject var viewModelPost = PostViewModel()
    @StateObject var viewModelUser = UserViewModel()
    @StateObject var viewModelReport = ReportViewModel()
    @StateObject var viewModelLogin = LoginViewModel()
    
    @State var avatarURL: URL?
    @State var insetoSelecionado: String = ""
    
    @State var comunidadeSel: String = "FORMIGAS"
    
    var comunidades: [String] = ["FORMIGAS", "ROBOS", "PADRINHOSMAGICOS"]
    
    var filteredPosts: [Post] {
        if comunidadeSel.isEmpty {
            return viewModelPost.posts
        } else {
            return viewModelPost.posts.filter { post in
                let postComunidade = community(from: post.text)
                return postComunidade == comunidadeSel
            }
        }
    }
    
    func community(from text: String) -> String {
        let components = text.components(separatedBy: "!@#$%ˆ&*")
        return components.first ?? ""
    }
    
    func extractedString(from text: String) -> String {
        let components = text.components(separatedBy: "!@#$%ˆ&*")
        return components[1]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background_insects")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button {
                            showingSheetPost = true
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.verdeescuro)
                        }
                        
                        .sheet(isPresented: $showingSheetPost) {
                            NavigationStack {
                                ZStack{
                                    Color("skyblue")
                                        .ignoresSafeArea()
                                    
                                    SheetViewPost( textCount: textCount, viewModel: viewModel, viewModelLogin: viewModelLogin, viewModelPost: viewModelPost)
                                }
                            }
                            .presentationDetents([.height(250)])
                            .presentationDragIndicator(.visible)
                            
                        }
                        
                        Button {
                            showingSheetCharacter = true
                        } label: {
                            Image(systemName: "ladybug.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.pink)
                        }
                        .scaledToFit()
                        .rotationEffect(.degrees(30.0))
                        .sheet(isPresented: $showingSheetCharacter) {
                            ZStack{
                                Color("skyblue")
                                    .ignoresSafeArea()
                                
                                SheetViewCharacter(viewModel: viewModel, insetoSelecionado: $insetoSelecionado, avatarURL: avatarURL, viewModelUser: viewModelUser, viewModelLogin: viewModelLogin)
                                    .presentationDetents([.medium])
                                    .presentationDragIndicator(.visible)
                            }
                        }
                    }
                    .frame(width: 100, height: 100)
                    .padding(.leading, 250)
                    
                    ScrollView {
                        ForEach(filteredPosts) { post in
                            PostView(text: extractedString(from: post.text), viewModel: viewModel, textCount: textCount, viewModelPost: viewModelPost, post: post, userToken: viewModelLogin.tokenLogin!, user: viewModelLogin.user, insetoSelecionado: $insetoSelecionado)
                        }
                    }
                }
                .onChange(of: viewModelPost.posts) { _ in
                    
                    print("Posts updated")
                }
                .onAppear {
                    Task {
                        do {
                            try await viewModelPost.fetchPosts()
                            try await viewModelUser.fetchUsers()
                        } catch {
                            viewModelPost.errorMessage = "erro carregar posts: \(error.localizedDescription)"
                        }
                    }
                }
            }
            .onAppear {
                if let avatarString = viewModelUser.user?.avatar, !avatarString.isEmpty {
                    avatarURL = URL(string: "\(API.baseURL)/\(avatarString)")
                }
            }
        }
    }
}

class CharacterViewModel: ObservableObject {
    @Published var selectedCharacter: String? = nil
}


#Preview {
    TimeLineView()
}

