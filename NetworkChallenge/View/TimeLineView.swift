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
                let postComunidade = comunidade(from: post.text)
                return postComunidade == comunidadeSel
            }
        }
    }
    
    func comunidade(from text: String) -> String {
        let components = text.components(separatedBy: "!@#$%ˆ&*")
        return components.first ?? ""
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
                                    
                                    SheetViewPost( textCount: textCount, viewModel: viewModel)
                                }
                            }
                            .presentationDetents([.height(250)])
                            .presentationDragIndicator(.hidden)
                            
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
//                        .rotationEffect(.degrees(30.0))
                        .sheet(isPresented: $showingSheetCharacter) {
                            ZStack{
                                Color("skyblue")
                                    .ignoresSafeArea()
                                
                                SheetViewCharacter(viewModel: viewModel, insetoSelecionado: $insetoSelecionado, avatarURL: avatarURL, viewModelUser: viewModelUser, viewModelLogin: viewModelLogin)
                                    .presentationDetents([.medium])
                                    .presentationDragIndicator(.hidden)
                            }
                        }
                    }
                    .frame(width: 100, height: 100)
                    .padding(.leading, 250)
                    
                    ScrollView {
                        ForEach(viewModelPost.posts) { post in
                            PostView(text: post.text, viewModel: viewModel, textCount: textCount, viewModelPost: viewModelPost, post: post, userToken: viewModelLogin.tokenLogin!, user: viewModelLogin.user, insetoSelecionado: $insetoSelecionado, avatarURL: avatarURL)
                        }
                    }
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
                    avatarURL = URL(string: "http://127.0.0.1:8080/\(avatarString)")
                }
            }
        }
    }
}


struct SheetViewPost: View {
    @Environment(\.dismiss) var dismiss
    @State private var characterLimit = 150
    @ObservedObject var textCount: TextCount
    @ObservedObject var viewModel: CharacterViewModel
    
    var body: some View {
        NavigationStack{
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
                    Button("Post") {
                        //                        sendText(textCount.text)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
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
            Text("Select character")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.white)
            
            VStack {
                ForEach(0..<avatarInsetos.count) { index in
                    Image(avatarInsetos[index])
                    .resizable()
                    .frame(width: 60, height: 60)
                    .onTapGesture {
                        insetoSelecionado = avatarInsetos[index]
                        Task {
                            do {
                                if let avatarData = UIImage(named: avatarInsetos[index])?.pngData() {
                                    try await viewModelUser.patchAvatar(with: viewModelLogin.tokenLogin!, with: avatarData)
                                    
                                    DispatchQueue.main.async {
                                        viewModelLogin.user?.avatar = avatarInsetos[index]
                                        avatarURL = URL(string: "http://127.0.0.1:8080/\(avatarInsetos[index])")
                                    }
                                }
                            } catch {
                                print("erro avatar: \(error)")
                            }
                        }
                    }
                    
                }
            }
            Button("Press to dismiss") {
                dismiss()
            }
            .foregroundColor(.white)
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
                if isMyPost { // se for autoral deleta se for dos outros reporta
                    Button(action: {
                        // integracao del post
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                } else {
                    Button(action: {
                        self.report.toggle()
                    }) {
                        Image(systemName: report ? "exclamationmark.bubble.fill" : "exclamationmark.bubble")
                            .foregroundColor(.yellow)
                    }
                }
                
                Image("whitecloud2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 330)
                    .padding(.top, 50)
                    .padding(.leading, 50)
                    .foregroundColor(.white)
                    .opacity(0.6)
            }
            .frame(width: 300)
            
            if let avatarUrl = avatarURL {
                AsyncImage(url: avatarURL) { image in
                    image
                        .resizable()
                        .frame(width: 60, height: 60)
                } placeholder: {
                    if !insetoSelecionado.isEmpty {
                        Image(insetoSelecionado)
                            .resizable()
                            .frame(width: 60, height: 60)
                    } else {
                        ProgressView()
                            .frame(width: 60, height: 60)
                    }                      }
            } else {
                Image("insect_1")
                    .resizable()
                    .frame(width: 60, height: 60)
            }
            
            if let character = viewModel.selectedCharacter {
                Image(character)
                    .resizable()
                    .frame(width: 45, height: 90)
                    .padding(.leading)
                    .padding(.top, 200)
                    .rotationEffect(.degrees(130.0))
            }
            
            Text(text)
                .font(.body)
                .padding(.leading, 80)
            //                .padding(.trailing, 70)
                .frame(width: 300, height: 330)
                .padding(.top, 40)
            //                .padding(.leading, 80)
            
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
                    .padding(.top, 150)
                    .padding(.leading, 320)
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
    @Published var counted = "0/150"
    @Published var text = "" {
        didSet {
            counted = String("\(text.count)/150")
        }
    }
}

struct TextDisplayView: View {
    @ObservedObject var textCount: TextCount
    
    var body: some View {
        Text(textCount.text.isEmpty ? "" : textCount.text)
            .padding()
    }
}

#Preview {
    TimeLineView()
}


//            TextDisplayView(textCount: textCount)
//                .frame(width: 300, height: 330)
//                .padding(.top, 40)
//                .padding(.leading, 80)
//.foregroundColor(.white)
