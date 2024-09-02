import SwiftUI

struct LogoutView: View {

    @ObservedObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                TextField("usuario", text: $viewModel.username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                TextField("senha", text: $viewModel.password)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                Button(action: {
                    Task {
                        try await viewModel.login(on: viewModel.baseURL)
                    }
                }) {
                    Text("Login")
                }
                .padding()


                Button(action: {
                    Task {
                        try await viewModel.logout(on: viewModel.baseURL, with: viewModel.tokenLogin!)
                    }
                }) {
                    Text("Logout")
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
    LogoutView()
}
