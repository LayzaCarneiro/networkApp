//
//  PostView.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 10/09/24.
//

import SwiftUI

struct PostView: View {
    @State private var isLiked = false
    @State var text: String = ""
    @State private var likingUsers: [User] = []
    @State private var report = false
    @State private var isMyPost = false
    
    @ObservedObject var viewModel: CharacterViewModel
    @ObservedObject var textCount: TextCount
    
    @StateObject var viewModelPost = PostViewModel()
    @StateObject var viewModelLogin = LoginViewModel()

    var post: Post
    var userToken: String
    var user: User?
    
    @Binding var insetoSelecionado: String
    @State var avatarURL: URL?
    
    func deletePost(post: Post) {
        Task {
            do {
                try await deletar(postID: post.id)
                viewModelPost.posts.removeAll { $0.id == post.id }
            } catch {
                viewModelPost.errorMessage = "Erro ao deletar: \(error.localizedDescription)"
            }
        }
    }

    func deletar(postID: UUID) async throws {
        let url = API.baseURL.appendingPathComponent("posts/\(postID.uuidString)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(viewModelLogin.tokenLogin ?? "")"
        ]
        _ = try await URLSession.shared.data(for: request)
        
    }


    func reportPost(with token: String, postID: UUID, reason: String) async throws {
        let url = API.baseURL.appendingPathComponent("reports/\(postID)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(reason)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        _ = try await URLSession.shared.data(for: request)
        print("Post \(postID) reportado")
    }

    func reportar(post: Post) {
        Task {
            do {
                try await reportPost(with: viewModelLogin.tokenLogin ?? "", postID: post.id, reason: "Motivo")
            } catch {
                viewModelPost.errorMessage = "Erro ao reportar: \(error.localizedDescription)"
            }
        }
    }

    
    var body: some View {
        
        ZStack {
            Image("tree")
                .resizable()
                .scaledToFill()
                .padding(.bottom, -400)
            
            HStack {
                if post.user == user { // se for autoral deleta se for dos outros reporta
                    Button(action: {
                        Task {
                            do {
                                try await deletar(postID: post.id)
                                viewModelPost.posts.removeAll { $0.id == post.id }
                            } catch {
                                viewModelPost.errorMessage = "Erro ao deletar: \(error.localizedDescription)"
                            }
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .padding(.leading, 5)
                } else {
                    Button(action: {
                        Task {
                            do {
                                try await reportPost(with: viewModelLogin.tokenLogin ?? "", postID: post.id, reason: "Motivo")
                            } catch {
                                viewModelPost.errorMessage = "Erro ao reportar: \(error.localizedDescription)"
                            }
                        }
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
                            .rotationEffect(.degrees(130.0))
                    } else {
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
            
            Text("\(post.user?.username ?? "Sharkberry"):")
                .font(.title3, weight: .semibold)
                .padding(.top, -70)
                .padding(.leading, 10)
                .foregroundColor(.verdeescuro)
            
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
            .frame(width: 100, height: 100)
//            .background(.red)
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
