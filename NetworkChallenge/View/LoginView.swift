import SwiftUI

struct LoginView: View {
    
    @ObservedObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    Task {
                        try await viewModel.login(on: viewModel.baseURL)
                        viewModel.isAuthenticated = true
                    }
                }) {
                    Text("Login")
                }
                .padding()
                
                if let user = viewModel.user {
                    Text("usuario \(user.username)")
                        .font(.title)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
