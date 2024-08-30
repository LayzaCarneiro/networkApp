import SwiftUI

struct CreateUserView: View {
    
    @ObservedObject var viewModelUser = UserViewModel()
    @State private var isPasswordValid: Bool = true
    @State private var isUsernameValid: Bool = true
    @State private var isUsernameAvailable: Bool = true
    @State private var showErrorMessages: Bool = false
    
    func checkUsername(username: String) -> Bool {
        return !viewModelUser.users.contains { $0.username == username }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Criar conta")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            TextField("Nome", text: $viewModelUser.name)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            TextField("Usuário", text: $viewModelUser.username)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(showErrorMessages && (!isUsernameValid || !isUsernameAvailable) ? Color.red : Color.gray, lineWidth: 1))
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if showErrorMessages && !isUsernameValid {
                Text("O usuário deve possuir 5 ou mais caracteres.")
                    .font(.caption)
                    .foregroundColor(.red)
            } else if showErrorMessages && !isUsernameAvailable {
                Text("O nome de usuário já existe.")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            SecureField("Senha", text: $viewModelUser.password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(showErrorMessages && !isPasswordValid ? Color.red : Color.gray, lineWidth: 1))
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if showErrorMessages && !isPasswordValid {
                Text("Sua senha deve possuir 5 ou mais caracteres.")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
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
                                await viewModelUser.fetchUsers()
                            } catch {
                                print("erro na criacao do user: \(error)")
                            }
                        }
                    }
                }
                
                showErrorMessages = true
            }) {
                Text("Criar conta")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pink)
                    .cornerRadius(10)
            }
            .disabled(viewModelUser.name.isEmpty || viewModelUser.username.isEmpty || viewModelUser.password.isEmpty)
            
        }
        .onAppear {
            Task {
                await viewModelUser.fetchUsers()
            }
        }
        .padding()
    }
}

#Preview {
    CreateUserView()
}
