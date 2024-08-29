//import SwiftUI
//
//extension Data {
//    mutating func append(_ string: String) {
//        if let data = string.data(using: .utf8) {
//            append(data)
//        }
//    }
//}
//
//struct LoginView: View {
//
//    @ObservedObject private var viewModel = LoginViewModel()
//    @ObservedObject private var postViewModel = PostViewModel()
//
//    @State private var isAuthenticated: Bool = false
//
//    func check(data: Data?, response: URLResponse) throws {
//        if let response = response as? HTTPURLResponse {
//            switch response.statusCode {
//            case 200..<300:
//                print("😸 Sucesso! \(response.statusCode)")
//            default:
//                print("🙀 Erro \(response.statusCode)")
//                throw APIError.apiError(code: response.statusCode, body: data)
//            }
//        }
//    }
//
//    func createPost(on baseURL: URL, text: String, media: String?, likeCount: Int?, createdAt: Date, updatedAt: Date, userID: UUID) async throws -> Post {
//        let url = baseURL.appending(path: "posts")
//
//        let boundary = UUID().uuidString
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = [
//            "Content-Type": "multipart/form-data; boundary=\(boundary)",
//            "Authorization": "Bearer \(viewModel.tokenLogin ?? "")"
//        ]
//
//        var body = Data()
//
//        func append(_ string: String) {
//            if let data = string.data(using: .utf8) {
//                body.append(data)
//            }
//        }
//
//        append("--\(boundary)\r\n")
//        append("Content-Disposition: form-data; name=\"text\"\r\n\r\n")
//        append(text)
//        append("\r\n")
//
//        append("--\(boundary)\r\n")
//        append("Content-Disposition: form-data; name=\"likeCount\"\r\n\r\n")
//        append("\(likeCount ?? 0)")
//        append("\r\n")
//
//        append("--\(boundary)\r\n")
//        append("Content-Disposition: form-data; name=\"createdAt\"\r\n\r\n")
//        append(ISO8601DateFormatter().string(from: createdAt))
//        append("\r\n")
//
//        append("--\(boundary)\r\n")
//        append("Content-Disposition: form-data; name=\"updatedAt\"\r\n\r\n")
//        append(ISO8601DateFormatter().string(from: updatedAt))
//        append("\r\n")
//
//        append("--\(boundary)\r\n")
//        append("Content-Disposition: form-data; name=\"userID\"\r\n\r\n")
//        append(userID.uuidString)
//        append("\r\n")
//
//        if let media = media, let mediaData = media.data(using: .utf8) {
//            append("--\(boundary)\r\n")
//            append("Content-Disposition: form-data; name=\"media\"; filename=\"media.txt\"\r\n")
//            append("Content-Type: text/plain\r\n\r\n")
//            body.append(mediaData)
//            append("\r\n")
//        }
//
//        append("--\(boundary)--\r\n")
//
//        request.httpBody = body
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        try check(data: data, response: response)
//
//        let post = try JSONDecoder().decode(Post.self, from: data)
//
//        return post
//    }
//
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 20) {
//                TextField("usuario", text: $viewModel.username)
//                    .autocapitalization(.none)
//                    .disableAutocorrection(true)
//                TextField("senha", text: $viewModel.password)
//                    .autocapitalization(.none)
//                    .disableAutocorrection(true)
//
//                Button(action: {
//                    Task {
//                        try await viewModel.login(on: viewModel.baseURL)
//                        isAuthenticated = true
//                        print("entrou")
//                        try await viewModel.me(on: viewModel.baseURL, with: viewModel.tokenLogin ?? "")
//
//                    }
//                }) {
//                    Text("Login")
//                }
//                .padding()
//
//                Button(action: {
//                    Task {
//
//                        try await viewModel.logout(on: viewModel.baseURL, with: viewModel.tokenLogin ?? "")
//                        isAuthenticated = false
//                        print("saiu")
//
//                    }
//                }) {
//                    Text("Logout")
//                }
//                .padding()
//
//                Button(action: {
//                    Task {
//                        do {
//                            let post = try await createPost(
//                                on: viewModel.baseURL,
//                                text: "texto tralalala",
//                                media: "opcional",
//                                likeCount: 0,
//                                createdAt: Date(),
//                                updatedAt: Date(),
//                                userID: viewModel.user!.id
//                            )
//
//                            print("deu bom \(post)")
//                        } catch {
//                            print("deu ruim \(error.localizedDescription)")
//                        }
//                    }
//                }) {
//                    Text("Post")
//                }
//                .padding()
//
//                if let user = viewModel.user, isAuthenticated {
//                    Text("usuario logado: \(user.username)")
//                        .font(.title)
//                        .padding()
//                } else if !isAuthenticated {
//                    Text("nenhum usuario logado")
//                }
//
//            }
//        }
//    }
//}
//
//#Preview {
//    LoginView()
//}
