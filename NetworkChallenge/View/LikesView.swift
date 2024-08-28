////
////  LikesView.swift
////  NetworkChallenge
////
////  Created by Layza Maria Rodrigues Carneiro on 27/08/24.
////
//
//import SwiftUI
//
//struct LikesView: View {
//    @StateObject var viewModelPost = PostViewModel()
//    @State var isLiked = false
//    @State var userToken: String = ""
//
//    var body: some View {
//        VStack {
//            if viewModelPost.posts.isEmpty {
//                Text("Nenhum post encontrado.")
//                    .padding()
//            } else {
//                List(viewModelPost.posts, id: \.id) { post in
//                    VStack(alignment: .leading) {
//                        Text(post.text)
//                            .font(.headline)
//                        
////                        if let users = try await viewModelPost.postLikingUsers(on: viewModelPost.baseURL, postId: post.id, with: userToken) {
////
////                        }
//                        
//                        
//                        HStack {
//                            Text("Likes: \(post.likeCount ?? 0)")
//                                .font(.subheadline)
//                            
//                            Button{
//                                Task {
//                                    
//                                    if(!isLiked) {
//                                        try await viewModelPost.likePost(on: viewModelPost.baseURL, postId: post.id, with: userToken)
//                                    } else {
//                                        try await viewModelPost.dislikePost(on: viewModelPost.baseURL, postId: post.id, with: userToken)
//                                    }
//                                }
//                                isLiked.toggle()
//                            } label: {
//                                Text(isLiked ? "Descurtir" : "Curtir")
//                                    .foregroundColor(.blue)
//                            }
//                        }
//                    }
//                    .padding()
//                }
//            }
//
//            if let errorMessage = viewModelPost.errorMessage {
//                Text("Erro: \(errorMessage)")
//                    .foregroundColor(.red)
//                    .padding()
//            }
//        }
//        .onAppear {
//            Task {
//                await viewModelPost.fetchPosts()
//                
////            let jpgData = UIImage(named: "Image")!.jpegData(compressionQuality: 0.5)
////            let pngData = UIImage(named: "Image")!.pngData()
//            }
//        }
//    }
//}
//
//#Preview {
//    LikesView()
//}
