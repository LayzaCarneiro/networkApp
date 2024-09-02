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
        NavigationStack {
            
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
                        
                        LoginTicket(placeholder: "Nome", textfield: "textfield", field: $viewModelUser.name, frameTextfield: 280)
                        
                        Spacer()
                        
                        if showErrorMessages && !isUsernameValid {
                            LoginTicket(placeholder: "Usuário", textfield: "wrongTextfield", field: $viewModelUser.username, frameTextfield: 280)
                            
                            Text("O usuário deve possuir 5 ou mais caracteres.")
                                .font(.caption1)
                                .foregroundColor(.red)
                            
                        } else if showErrorMessages && !isUsernameAvailable {
                            LoginTicket(placeholder: "Usuário", textfield: "wrongTextfield", field: $viewModelUser.username, frameTextfield: 280)
                            
                            Text("O nome de usuário já existe.")
                                .font(.caption1)
                                .foregroundColor(.red)
                        } else {
                            LoginTicket(placeholder: "Usuário", textfield: "textfield", field: $viewModelUser.username, frameTextfield: 280)
                        }

                        Spacer()
                        
                        if showErrorMessages && !isPasswordValid {
                            LoginTicket(placeholder: "Senha", textfield: "wrongTextfield", field: $viewModelUser.password, isSecure: true , frameTextfield: 280)
                            
                            Text("Sua senha deve possuir 5 ou mais caracteres.")
                                .font(.caption1)
                                .foregroundColor(.red)
                        } else {
                            LoginTicket(placeholder: "Senha", textfield: "textfield", field: $viewModelUser.password, isSecure: true , frameTextfield: 280)
                        }
                        
                    }
                    .frame(height: 250)
                }
                
                Spacer()
                
                Button {
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
                } label: {
                    Text("Criar conta")
                        .font(.title2)
                        .foregroundColor(.backgroundOffWhite)
                        .fontWeight(.semibold)
                        .padding()
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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Cadastro")
                        .fontWeight(.semibold)
                        .foregroundColor(.brownPixel)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CreateUserView()
}
