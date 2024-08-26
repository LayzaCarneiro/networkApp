//import SwiftUI
//
//struct ContentView: View {
//    @ObservedObject var viewModelUser = UserViewModel()
//    @ObservedObject var viewModelPost = PostViewModel()
//
//    var body: some View {
//
//                VStack {
//                    if viewModelUser.users.isEmpty {
//                        Text("Nenhum usuário encontrado.")
//                            .padding()
//                    } else {
//
//                        List(viewModelUser.users, id: \.id) { user in
//                            Text(user.username)
//                        }
//                    }
//
//                    if let errorMessage = viewModelUser.errorMessage {
//                        Text("Erro: \(errorMessage)")
//                            .foregroundColor(.red)
//                            .padding()
//                    }
//                }
//                .onAppear {
//                    Task {
//                        await viewModelUser.fetchUsers()
//                    }
//                }
//                .padding()
//
//
//        VStack {
//            if viewModelPost.posts.isEmpty {
//                Text("Nenhum post encontrado.")
//                    .padding()
//            } else {
//
//                List(viewModelPost.posts, id: \.id) { post in
//                    Text(post.text ?? "")
//                }
//            }
//
//            if let errorMessage = viewModelPost.errorMessage {
//                Text("deu erro: \(errorMessage)")
//                    .foregroundColor(.red)
//                    .padding()
//            }
//        }
//        .onAppear {
//            Task {
//                do {
//                    try await viewModelPost.fetchPosts()
//                } catch {
//                    viewModelPost.errorMessage = "Erro ao carregar posts: \(error.localizedDescription)"
//                }
//            }
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}
import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var viewModel = LoginViewModel()
    @State private var isAuthenticated: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("usuario", text: $viewModel.username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                TextField("senha", text: $viewModel.password)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button(action: {
                    Task {
                        try await viewModel.login(on: viewModel.baseURL)
                        isAuthenticated = true
                        print("entrou")
                        try await viewModel.me(on: viewModel.baseURL, with: viewModel.tokenLogin ?? "")
                    }
                }) {
                    Text("Login")
                }
                .padding()
                
                Button(action: {
                    Task {
                        try await viewModel.logout(on: viewModel.baseURL, with: viewModel.tokenLogin ?? "")
                        isAuthenticated = false
                        print("saiu")
                    }
                }) {
                    Text("Logout")
                }
                .padding()
                
                NavigationLink(destination: CreatePostView(viewModel: viewModel, isAuthenticated: $isAuthenticated)) {
                    Text("link para criar post")
                }
                .padding()
                .disabled(!isAuthenticated)
                
                if let user = viewModel.user, isAuthenticated {
                    Text("usuario logado: \(user.username)")
                        .font(.title)
                        .padding()
                } else if !isAuthenticated {
                    Text("nenhum usuario logado")
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
