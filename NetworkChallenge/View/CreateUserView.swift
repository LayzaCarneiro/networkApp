import SwiftUI

struct CreateUserView: View {
    
    @ObservedObject var viewModel = UserViewModel()
    
    var body: some View {
        VStack {
            TextField("nome", text: $viewModel.name)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            TextField("usuario", text: $viewModel.username)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            TextField("senha", text: $viewModel.password)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            Button(action: {
                Task {
                    do {
                        let usuario = try await viewModel.createUser(on: viewModel.baseURL)
                        print("user criado: \(usuario)")
                        await viewModel.fetchUsers()
                    } catch {
                        print("deu ruim \(error)")
                    }
                }
            }) {
                Text("Criar usuario lalaainit")
            }

        }
        .padding()
    }
}

#Preview {
    CreateUserView()
}
