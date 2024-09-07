import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var viewModelLogin = LoginViewModel()
    @ObservedObject private var viewModelPost = PostViewModel()

    @State private var navFeed = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                VStack(spacing: 15) {
                    CustomTextField(placeholder: "Usuário", text: $viewModelLogin.username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    CustomTextField(placeholder: "Senha", text: $viewModelLogin.password, isSecure: true)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal, 20)

                Button(action: {
                    Task {
                        do {
                            try await viewModelLogin.login()
                            print("fez login")
                            navFeed = true
                        } catch {
                            print("Login error: \(error)")
                        }
                    }
                }) {
                    Text("Fazer Login")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .navigationDestination(isPresented: $navFeed) {
                    HomeView(
                        viewModelLogin: viewModelLogin,
                        viewModelPost: viewModelPost
                    )
                }
            }
            .padding()
        }
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        if isSecure {
            SecureField(placeholder, text: $text)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
        } else {
            TextField(placeholder, text: $text)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
        }
    }
}

#Preview {
    ContentView()
}
