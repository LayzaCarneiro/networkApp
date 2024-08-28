import SwiftUI

//struct ContentView: View {
//    @ObservedObject var viewModelUser = UserViewModel()
//    @ObservedObject var viewModelPost = PostViewModel()
//    
//    var body: some View {
//
//        VStack {
//            if viewModelUser.users.isEmpty {
//                Text("Nenhum usuário encontrado.")
//                    .padding()
//            } else {
//
//                List(viewModelUser.users, id: \.id) { user in
//                    Text(user.username)
//                }
//            }
//
//            if let errorMessage = viewModelUser.errorMessage {
//                Text("Erro: \(errorMessage)")
//                    .foregroundColor(.red)
//                    .padding()
//            }
//        }
//        .onAppear {
//            Task {
//                await viewModelUser.fetchUsers()
//            }
//        }
//        .padding()
//
//        VStack {
//            if viewModelPost.posts.isEmpty {
//                Text("Nenhum post encontrado.")
//                    .padding()
//            } else {
//
//                List(viewModelPost.posts, id: \.id) { post in
//                    Text(post.text)
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
//                await viewModelPost.fetchPosts()
//            }
//
//        }
//        .padding()
//    }
//}
//

struct ContentView: View {
    
    @ObservedObject private var viewModel = LoginViewModel()
    @State private var isAuthenticated: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Usuario", text: $viewModel.username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                TextField("Senha", text: $viewModel.password)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            
                Button {
                    Task {
                        do {
                            try await viewModel.login(on: viewModel.baseURL)
                            isAuthenticated = true
                            try await viewModel.me(on: viewModel.baseURL, with: viewModel.tokenLogin ?? "")
                        } catch {
                            print("Erro: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Text("Login")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .navigationTitle("Página Inicial")
                
                Button {
                    Task {
                        try await viewModel.logout(on: viewModel.baseURL, with: viewModel.tokenLogin ?? "")
                        isAuthenticated = false
                    }
                } label: {
                    Text("Logout")
                }
                .padding()
                
                if(isAuthenticated) {
                    LikesView(userToken: viewModel.tokenLogin ?? "")
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
