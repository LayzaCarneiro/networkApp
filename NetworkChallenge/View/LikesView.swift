//
//  LikesView.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 27/08/24.
//

import SwiftUI

struct LikesView: View {
    @StateObject var viewModelPost = PostViewModel()
    @State var userToken: String = ""
    @State var user: User?

    var body: some View {
        VStack {
            if viewModelPost.posts.isEmpty {
                Text("Nenhum post encontrado.")
                    .padding()
            } else {
                List(viewModelPost.posts) { post in
                    PostRowView(post: post, userToken: userToken, user: user)
                }
            }

            if let errorMessage = viewModelPost.errorMessage {
                Text("Erro: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            Task {
                await viewModelPost.fetchPosts()
            }
        }
    }
}

struct PostRowView: View {
    @StateObject var viewModelPost = PostViewModel()
    var post: Post
    var userToken: String
    var user: User?
    
    @State private var likingUsers: [User] = []
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(post.text)
                .font(.headline)
            
            HStack {
                Text("Likes: \(post.like_count ?? 0)")
                    .font(.subheadline)

                Button {
                    Task {
                        let users = try await viewModelPost.postLikingUsers(on: viewModelPost.baseURL, postId: post.id, with: userToken)
                        likingUsers = users

                        if let user = user, likingUsers.contains(where: { $0.id == user.id }) {
                            isLiked = false
                            try await viewModelPost.dislikePost(on: viewModelPost.baseURL, postId: post.id, with: userToken)
                        } else {
                            isLiked = true
                            try await viewModelPost.likePost(on: viewModelPost.baseURL, postId: post.id, with: userToken)
                        }

                        // Atualiza a contagem de likes após a operação
                        await viewModelPost.fetchPosts()
                    }
                } label: {
                    Text(isLiked ? "Descurtir" : "Curtir")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                if let user = user {
                    let users = try await viewModelPost.postLikingUsers(on: viewModelPost.baseURL, postId: post.id, with: userToken)
                    likingUsers = users
                    isLiked = likingUsers.contains(where: { $0.id == user.id })
                }
            }
        }
    }
}

#Preview {
    LikesView()
}
