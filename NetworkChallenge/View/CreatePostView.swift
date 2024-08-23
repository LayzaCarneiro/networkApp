import SwiftUI

struct CreatePostView: View {
    
    @ObservedObject var viewModel = PostViewModel()
    @ObservedObject var viewModelUser = UserViewModel()
    var body: some View {
        VStack {
            
            Button(action: {
                Task {
                    do {
                        let login = try await viewModelUser.login(on: viewModelUser.baseURL)

                        let post = try await viewModel.createPost(on: viewModel.baseURL)
                        print("post criado: \(post)")
                        
                    } catch {
                        print("deu ruim \(error)")
                    }
                }
            }) {
                Text("Criar post")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
}

#Preview {
    CreatePostView()
}
