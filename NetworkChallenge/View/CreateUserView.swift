import SwiftUI

struct CreateUserView: View {

    @ObservedObject private var viewModelLogin = LoginViewModel()
    @ObservedObject private var viewModelPost = PostViewModel()
    @ObservedObject var viewModelUser = UserViewModel()
    @State var isPasswordValid: Bool = true
    @State var isUsernameValid: Bool = true
    @State var isUsernameAvailable: Bool = true
    @State var showErrorMessages: Bool = false
    @State var navFeed = false

    func checkUsername(username: String) -> Bool {
        return !viewModelUser.users.contains { $0.username == username }
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Spacer()
            Spacer()
            ZStack {
                VStack {
                    Image("fundoCadastro")
                        .resizable()
                        .scaledToFit()
                }
                .padding(.horizontal, 25)

                VStack {
                    //                    TextField("", text: $text, prompt: Text("Placeholder"))

                    TextField("Nome", text: $viewModelUser.name)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(
                            Image("fundoTextField")
                                .resizable()
                                .scaledToFit()
                        )
                        .disableAutocorrection(true)
                        .padding(.horizontal, 50)

                    Spacer()
                    TextField("Usuário", text: $viewModelUser.username)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(
                            Image("fundoTextField")
                                .resizable()
                                .scaledToFit()
                        )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 50)
                    Spacer()

                    SecureField("Senha", text: $viewModelUser.password)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(
                            Image("fundoTextField")
                                .resizable()
                                .scaledToFit()
                        )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 50)
                }
                .frame(height: 250)
            }



            if showErrorMessages && !isUsernameValid {
                Text("O usuário deve possuir 5 ou mais caracteres.")
                    .font(.caption)
                    .foregroundColor(.red)
            } else if showErrorMessages && !isUsernameAvailable {
                Text("O nome de usuário já existe.")
                    .font(.caption)
                    .foregroundColor(.red)
            }

            if showErrorMessages && !isPasswordValid {
                Text("Sua senha deve possuir 5 ou mais caracteres.")
                    .font(.caption)
                    .foregroundColor(.red)
            }

            Spacer()
            Button(action: {
                isPasswordValid = viewModelUser.password.count >= 5
                isUsernameValid = viewModelUser.username.count >= 5

                if isPasswordValid && isUsernameValid {
                    isUsernameAvailable = checkUsername(username: viewModelUser.username)

                    if isUsernameAvailable {
                        Task {
                            do {
                                let usuario = try await viewModelUser.createUser(on: viewModelUser.baseURL)
                                print("user: \(usuario)")
                                viewModelLogin.username = viewModelUser.username
                                viewModelLogin.password = viewModelUser.password
                                try await viewModelLogin.login(on: viewModelLogin.baseURL)
                                navFeed = true
                            } catch {
                                print("erro na criacao do user: \(error)")
                            }
                        }
                    }
                }

                showErrorMessages = true
            }) {
                Text("Criar conta")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.fundoAmarelo)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .fontWeight(.heavy)
            }
            .disabled(viewModelUser.name.isEmpty || viewModelUser.username.isEmpty || viewModelUser.password.isEmpty)
            .background(
                Image("botao")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
            )
            .navigationDestination(isPresented: $navFeed) {
                HomeView(viewModelLogin: viewModelLogin, viewModelPost: viewModelPost)
//                FeedView(
//                    viewModelLogin: viewModelLogin,
//                    viewModelPost: viewModelPost,
//                    onLogout: {
//                        navFeed = true
//
//                    }
//                )
            }

            Spacer()
            Spacer()
            Spacer()

        }
        .onAppear {
            Task {
                await viewModelUser.fetchUsers()
            }
        }
        .background(Color.fundoAmarelo)
    }
}

#Preview {
    CreateUserView()
}
