import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModelLogin: LoginViewModel
    @StateObject var viewModelPost = PostViewModel()
    @ObservedObject var viewModelUser = UserViewModel()
    @ObservedObject var viewModelReport = ReportViewModel()
    
    @State var navCreatePost = false
    @Environment(\.presentationMode) var presentationMode
    let onLogout: () -> Void

    func deletePost(_ indexSet: IndexSet) {
        for index in indexSet {
            let post = viewModelPost.posts[index]
            Task {
                do {
                    try await deletar(on: viewModelLogin.baseURL, postID: post.id)
                    viewModelPost.posts.remove(at: index)
                } catch {
                    viewModelPost.errorMessage = "Erro ao deletar: \(error.localizedDescription)"
                }
            }
        }
    }

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
                CreatePostView(viewModelLogin: viewModelLogin, viewModelPost: viewModelPost)
            }

            Button(action: {
                Task {
                    do {
                        try await viewModelLogin.logout(on: viewModelLogin.baseURL, with: viewModelLogin.tokenLogin ?? "")
                        print("logout feito")
                        onLogout()
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print("erro no logout: \(error)")
                    }
                }
            }) {
                Text("Logout")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            .padding(.top, 10)

            if viewModelPost.posts.isEmpty {
                Text("Nenhum post encontrado.")
                    .padding()
            } else {
                List {
                    ForEach(viewModelPost.posts.indices, id: \.self) { index in
                        Text("Usuário \(viewModelPost.posts[index].user?.username ?? "Desconhecido") postou: \(viewModelPost.posts[index].text)")
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.05)
                                         )                            )
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    deletePost(IndexSet(integer: index))
                                } label: {
                                    Label("Deletar", systemImage: "trash.fill")
                                }
                                Button {
                                    reportar(IndexSet(integer: index))
                                } label: {
                                    Label("Reportar", systemImage: "exclamationmark.triangle")
                                }
                                .tint(.blue)
                            }
                    }
                }
                .listStyle(PlainListStyle()) // Removes the default list row styling
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
        .navigationBarBackButtonHidden(true)
    }
}
