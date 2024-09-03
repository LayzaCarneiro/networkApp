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
                            PostView(text: extractedString(from: post.text), viewModel: viewModel, textCount: textCount, viewModelPost: viewModelPost, post: post, userToken: viewModelLogin.tokenLogin!, user: viewModelLogin.user, insetoSelecionado: $insetoSelecionado, avatarURL: avatarURL)
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


struct SheetViewPost: View {
    @Environment(\.dismiss) var dismiss
    @State private var characterLimit = 120
    @ObservedObject var textCount: TextCount
    @ObservedObject var viewModel: CharacterViewModel
    
    @StateObject var viewModelLogin = LoginViewModel()
    @StateObject var viewModelPost = PostViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                HStack {
                    if let character = viewModel.selectedCharacter {
                        Image(character)
                            .resizable()
                            .frame(width: 30, height:60)
                    }
                    
                    TextField("O que está acontecendo?", text: $textCount.text, axis: .vertical)
                        .multilineTextAlignment(.leading)
                        .onChange( of: textCount.text) { _ in
                            textCount.text = String(textCount.text.prefix(characterLimit))
                        }
                        .foregroundColor(.white)
                        .font(.title3)
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom, 80)
                Text("\(textCount.counted)")
                    .foregroundColor(.white)
                    .padding(.top, 200)
                    .padding(.leading, 250)
                
            }
            .overlay( RoundedRectangle(cornerRadius: 14) .stroke(.white, lineWidth: 2))
            .padding()
        }
        
        Spacer()
        
            .toolbar{
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            do {
                                print("comunidade selecionada formigas")
                                let postComunidade = "FORMIGAS!@#$%ˆ&*\(textCount.text)"
                                let post = try await viewModelPost.createPost(
                                    text: postComunidade,
                                    with: viewModelLogin.tokenLogin ?? ""
                                )
                                print("post \(post)")
                            } catch {
                                print("n foi: \(error.localizedDescription)")
                            }
                            await viewModelPost.fetchPosts()
                            dismiss()
                        }
                    } label: {
                        Text("Post")
                            .font(.title3)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.title3)
                    }
                }
            }
            .foregroundColor(.white)
    }
}

struct SheetViewCharacter: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CharacterViewModel
    
    @Binding var insetoSelecionado: String
    @State var avatarURL: URL?
    @StateObject var viewModelUser = UserViewModel()
    @StateObject var viewModelLogin = LoginViewModel()
    
    let avatarInsetos = ["insect_1", "insect_2", "insect_3", "insect_4"]
    
    var body: some View {
        VStack {
            Text("Selecione seu avatar")
                .font(.title2, weight: .bold)
                .foregroundStyle(.white)
            
            VStack {
                ForEach(0..<avatarInsetos.count) { index in
                    Button {
                        dismiss()
                    } label: {
                        Image(avatarInsetos[index])
                            .resizable()
                            .frame(width: 50, height: 75)
                            .onTapGesture {
                                insetoSelecionado = avatarInsetos[index]
                                Task {
                                    do {
                                        if let avatarData = UIImage(named: avatarInsetos[index])?.pngData() {
                                            try await viewModelUser.patchAvatar(with: viewModelLogin.tokenLogin!, with: avatarData)
                                            
                                            DispatchQueue.main.async {
                                                viewModelLogin.user?.avatar = avatarInsetos[index]
                                                avatarURL = URL(string: "\(API.baseURL)/\(avatarInsetos[index])")
                                            }
                                        }
                                    } catch {
                                        print("erro avatar: \(error)")
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
}

class CharacterViewModel: ObservableObject {
    @Published var selectedCharacter: String? = nil
}

struct PostView: View {
    @State private var isLiked = false
    @State var text: String = ""
    @State private var likingUsers: [User] = []
    @State private var report = false
    @State private var isMyPost = false
    
    @ObservedObject var viewModel: CharacterViewModel
    @ObservedObject var textCount: TextCount
    
    @StateObject var viewModelPost = PostViewModel()
    
    var post: Post
    var userToken: String
    var user: User?
    
    @Binding var insetoSelecionado: String
    @State var avatarURL: URL?
    
    var body: some View {
        
        ZStack {
            Image("tree")
                .resizable()
                .scaledToFill()
                .padding(.bottom, -400)
            
            HStack {
                if !isMyPost { // se for autoral deleta se for dos outros reporta
                    Button(action: {
                        // integracao del post
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .padding(.leading, 5)
                } else {
                    Button(action: {
                        self.report.toggle()
                    }) {
                        Image(systemName: report ? "exclamationmark.bubble.fill" : "exclamationmark.bubble")
                            .foregroundColor(.yellow)
                    }
                    .padding(.leading, 15)
                    .padding(.top, 8)
                }
                
                Image("whitecloud2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 330)
                    .padding(.top, 50)
                    .padding(.leading, 50)
                    .foregroundColor(.white)
                    .opacity(0.7)
            }
            .frame(width: 300)
            
            if let avatarUrl = avatarURL {
                AsyncImage(url: avatarURL) { image in
                    image
                        .resizable()
                        .frame(width: 45, height: 90)
                        .padding(.leading)
                        .padding(.top, 200)
                        .rotationEffect(.degrees(130.0))
                } placeholder: {
                    if !insetoSelecionado.isEmpty {
                        Image(insetoSelecionado)
                            .resizable()
                            .frame(width: 45, height: 90)
                            .padding(.leading)
                            .padding(.top, 200)
                            .rotationEffect(.degrees(130.0))                    } else {
                        ProgressView()
                            .frame(width: 60, height: 60)
                    }
                }
            } else {
                Image("insect_1")
                    .resizable()
                    .frame(width: 45, height: 90)
                    .padding(.leading)
                    .padding(.top, 200)
                    .rotationEffect(.degrees(130.0))
            }
            
            Text(text)
                .font(.body)
                .padding(.leading, 80)
                .frame(width: 300, height: 330)
                .padding(.top, 40)
            
            Button {
                Task {
                    let users = try await viewModelPost.postLikingUsers(postId: post.id, with: userToken)
                    likingUsers = users
                    
                    if let user = user, likingUsers.contains(where: { $0.id == user.id }) {
                        isLiked = false
                        try await viewModelPost.dislikePost(postId: post.id, with: userToken)
                    } else {
                        isLiked = true
                        try await viewModelPost.likePost(postId: post.id, with: userToken)
                    }
                    
                    await viewModelPost.fetchPosts()
                }
            } label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                    .padding(.top, 140)
                    .padding(.leading, 330)
            }
            
        }
        .onAppear {
            Task {
                if let user = user {
                    let users = try await viewModelPost.postLikingUsers(postId: post.id, with: userToken)
                    likingUsers = users
                    isLiked = likingUsers.contains(where: { $0.id == user.id })
                }
            }
        }
        .padding(.top, -60)
    }
}

class TextCount: ObservableObject {
    @Published var counted = "0/120"
    @Published var text = "" {
        didSet {
            counted = String("\(text.count)/120")
        }
    }
}

struct TextDisplayView: View {
    @ObservedObject var textCount: TextCount
    
    var body: some View {
        Text(textCount.text.isEmpty ? "" : textCount.text)
            .padding()
            .font(.body)
    }
}

#Preview {
    TimeLineView()
}
