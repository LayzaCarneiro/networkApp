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
    @State var login = false

    func checkUsername(username: String) -> Bool {
        return !viewModelUser.users.contains { $0.username == username }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.backgroundOffWhite.ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220)
                            .padding(.top, 20)
                        
                        Text("Cadastro")
                            .font(.title2, weight: .semibold)
                            .foregroundColor(.brownPixel)
                        
                        ZStack {
                            
                            Image("fundoCadastro")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 330)
                            
                            VStack(spacing: 30) {
                                
                                LoginTicket(placeholder: "Nome", textfield: "textfield", field: $viewModelUser.name,  paddingLeading: 75, frameTextfield: 270)
                                
                                if showErrorMessages && !isUsernameValid {
                                    LoginTicket(placeholder: "Usuário", textfield: "wrongTextfield", field: $viewModelUser.username, paddingLeading: 75, frameTextfield: 270)
                                    
                                    Text("O usuário deve possuir 5 ou mais caracteres.")
                                        .font(.caption1)
                                        .foregroundColor(.red)
                                    
                                } else if showErrorMessages && !isUsernameAvailable {
                                    LoginTicket(placeholder: "Usuário", textfield: "wrongTextfield", field: $viewModelUser.username, paddingLeading: 75, frameTextfield: 270)
                                    
                                    Text("O nome de usuário já existe.")
                                        .font(.caption1)
                                        .foregroundColor(.red)
                                } else {
                                    LoginTicket(placeholder: "Usuário", textfield: "textfield", field: $viewModelUser.username, paddingLeading: 75, frameTextfield: 270)
                                }
                                
                                if showErrorMessages && !isPasswordValid {
                                    LoginTicket(placeholder: "Senha", textfield: "wrongTextfield", field: $viewModelUser.password, isSecure: true, paddingLeading: 75,  frameTextfield: 270)
                                    
                                    Text("Sua senha deve possuir 5 ou mais caracteres.")
                                        .font(.caption1)
                                        .foregroundColor(.red)
                                } else {
                                    LoginTicket(placeholder: "Senha", textfield: "textfield", field: $viewModelUser.password, isSecure: true, paddingLeading: 75,  frameTextfield: 270)
                                }
                            }
                        }
                        .padding(.bottom, 28)
                        
                        Button {
                            isPasswordValid = viewModelUser.password.count >= 5
                            isUsernameValid = viewModelUser.username.count >= 5
                            
                            if isPasswordValid && isUsernameValid {
                                isUsernameAvailable = checkUsername(username: viewModelUser.username)
                                
                                if isUsernameAvailable {
                                    Task {
                                        do {
                                            let usuario = try await viewModelUser.createUser()
                                            print("user: \(usuario)")
                                            viewModelLogin.username = viewModelUser.username
                                            viewModelLogin.password = viewModelUser.password
                                            try await viewModelLogin.login()
                                            navFeed = true
                                        } catch {
                                            print("erro na criacao do user: \(error)")
                                        }
                                    }
                                }
                            }
                            
                            showErrorMessages = true
                        } label: {
                            ZStack {
                                Image("botao")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 100)
                                
                                Text("Criar conta")
                                    .font(.title2)
                                    .foregroundColor(.backgroundOffWhite)
                                    .fontWeight(.semibold)
                                    .padding()
                            }
                        }
                        .disabled(viewModelUser.name.isEmpty || viewModelUser.username.isEmpty || viewModelUser.password.isEmpty)
                        .navigationDestination(isPresented: $navFeed) {
                            LoginView()
                        }
                        
                        HStack(spacing: 0) {
                            
                            Text("Se já possui conta. ")
                                .font(.body, weight: .regular)
                                .foregroundStyle(.brownPixel)
                                .padding(.top, 15)
                            
                            Button {
                                login.toggle()
                            } label: {
                                Text("Faça o login.")
                                    .font(.body, weight: .regular)
                                    .underline(true, color: .brownPixel)
                                    .foregroundStyle(.brownPixel)
                                    .padding(.top, 15)
                            }
                            .navigationDestination(isPresented: $login) {
                                LoginView()
                            }
                        }
                        .padding(.top, -15)
                        
                    }
                }
                .onAppear {
                    Task {
                        await viewModelUser.fetchUsers()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    CreateUserView()
}
