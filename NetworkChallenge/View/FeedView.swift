import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModelLogin: LoginViewModel
    @StateObject var viewModelPost = PostViewModel()
    @ObservedObject var viewModelUser = UserViewModel()
    @ObservedObject var viewModelReport = ReportViewModel()
    
    @State var navCreatePost = false
    @Environment(\.presentationMode) var presentationMode
        
    let onLogout: () -> Void

//    func deletePost {
//        for index in indexSet {
//            let post = viewModelPost.posts[index]
//            Task {
//                do {
//                    try await deletar(on: viewModelLogin.baseURL, postID: post.id)
//                    viewModelPost.posts.remove(at: index)
//                } catch {
//                    viewModelPost.errorMessage = "Erro ao deletar: \(error.localizedDescription)"
//                }
//            }
//        }
//    }

    func reportar(_ indexSet: IndexSet) {
        for index in indexSet {
            let post = viewModelPost.posts[index]
            Task {
                do {
                    try await reportPost(on: viewModelLogin.baseURL, with: viewModelLogin.tokenLogin ?? "", postID: post.id, reason: "Motivo")
                } catch {
                    viewModelPost.errorMessage = "Erro ao reportar: \(error.localizedDescription)"
                }
            }
        }
    }

    func reportPost(on baseURL: URL, with token: String, postID: UUID, reason: String) async throws {
        let url = baseURL.appendingPathComponent("reports/\(postID)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(reason)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        _ = try await URLSession.shared.data(for: request)
        print("Post \(postID) reportado")
    }

    func deletar(on baseURL: URL, postID: UUID) async throws {
        let url = baseURL.appendingPathComponent("posts/\(postID.uuidString)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(viewModelLogin.tokenLogin ?? "")"
        ]
        _ = try await URLSession.shared.data(for: request)
        
    }

    @State var comunidadeSel: String = ""
    
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
    
    func texto(from text: String) -> String {
        let components = text.components(separatedBy: "!@#$%ˆ&*")
        return components.count > 1 ? components[1] : text
    }
    
    
    var body: some View {
        VStack {
            Image("op1")
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    Task {
                        do {
                            let avatar = UIImage(named: "op1")!.pngData()
                            try await viewModelUser.patchAvatar(with: viewModelLogin.tokenLogin!, with: avatar!, on: viewModelUser.baseURL)
                        } catch {
                            print("erro: \(error)")
                        }
                    }
                }

            Button(action: {
                navCreatePost = true
            }) {
                Text("Novo Post")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            .navigationDestination(isPresented: $navCreatePost) {
                CreatePostView(viewModelLogin: viewModelLogin, viewModelPost: viewModelPost, comunidadeSel: comunidadeSel)
            }

//            Button(action: {
//                Task {
//                    do {
//                        try await viewModelLogin.logout(on: viewModelLogin.baseURL, with: viewModelLogin.tokenLogin ?? "")
//                        print("logout feito")
//                        onLogout()
//                        presentationMode.wrappedValue.dismiss()
//                    } catch {
//                        print("erro no logout: \(error)")
//                    }
//                }
//            }) {
//                Text("Logout")
//                    .font(.headline)
//                    .foregroundColor(.red)
//            }
//            .padding(.top, 10)

            if viewModelPost.posts.isEmpty {
                Text("Nenhum post encontrado.")
                    .padding()
            } else {
                VStack {
//                    Picker("filtrar comunidade", selection: $comunidadeSel) {
//                        ForEach(comunidades, id: \.self) { comunidade in
//                            Text(comunidade).tag(comunidade)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                    .padding()
                    
                    if viewModelPost.posts.isEmpty {
                        Text("Nenhum post encontrado.")
                            .padding()
                    } else {
                        VStack {
                            List {
                                ForEach(filteredPosts) { post in
                                    HStack {
                                        VStack {
                                            Image("blusa")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .clipShape(Circle())
                                            HStack (spacing: 1) {
                                                Image(systemName: "heart")
                                                    .font(.system(size: 14))
                                                    .foregroundStyle(Color.gray)

                                                Text("\(post.like_count ?? 0)")
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(Color.gray)
                                            }
                                        }
                                        
                                        VStack (alignment: .leading) {
                                            HStack {
                                                Text("\(post.user?.username ?? "")")
                                                    .font(.system(size: 14))
                                                Text("há 15 minutos")
                                                    .font(.system(size: 14))
                                                    .foregroundStyle(Color.gray)
                                            }
                                            Text(texto(from: post.text))
                                                .padding()
                                                .background(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.gray.opacity(0.2))
                                                )
                                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                                    Button(role: .destructive) {
                                                        
                                                        Task {
                                                            do {
                                                                try await deletar(on: viewModelLogin.baseURL, postID: post.id)
                                                            } catch {
                                                                viewModelPost.errorMessage = "Erro ao reportar: \(error.localizedDescription)"
                                                            }
                                                        }
                                                        
                                                        
                                                    } label: {
                                                        Label("Deletar", systemImage: "trash.fill")

                                                    }
                                                    Button {
                                                    } label: {
                                                        Label("Reportar", systemImage: "exclamationmark.triangle")
                                                    }
                                                    .tint(.blue)
                                                }
                                        }
                                    }
                                    .onTapGesture(count: 2) {
                                        print("Double tapped!")
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                    }

                    if let errorMessage = viewModelPost.errorMessage {
                        Text("Erro: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    }
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
                do {
                    try await viewModelPost.fetchPosts()
                    try await viewModelUser.fetchUsers()
                } catch {
                    viewModelPost.errorMessage = "erro carregar posts: \(error.localizedDescription)"
                }
            }
        }
//        .navigationBarBackButtonHidden(true)
    }
}
