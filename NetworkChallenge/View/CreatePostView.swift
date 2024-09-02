import SwiftUI

struct CreatePostView: View {
    
    @ObservedObject var viewModelLogin: LoginViewModel
    @ObservedObject var viewModelPost: PostViewModel

    @State var postText: String = ""
    @State var likeCount: Int = 0
    @State var comunidade: String = ""

    @State var selectedImage: UIImage? = nil
    
    let comunidades: [String] = [
            "Somos humanos. Não robôs.",
            "Vida de inseto"
    ]

    @State var comunidadeSel: String = ""

    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Escreva seu post", text: $postText)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
            
//            TextField("midia", text: $media)
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
            
//            Picker("comunidades", selection: $comunidade) {
//                ForEach(comunidades, id: \.self) { comunidade in
//                    Text(comunidade)
//                }
//            }
//            .pickerStyle(MenuPickerStyle())
//            .padding()
//            .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
//                        .onChange(of: comunidade) { newValue in
//                            print("comunidade q escolheu: \(newValue)")
//                        }
//            
            Button(action: {
                Task {
                    do {
                        print("comunidade selecionada \(comunidadeSel)")
                        let postComunidade = "\(comunidadeSel)!@#$%ˆ&*\(postText)"
                        let post = try await viewModelPost.createPost(
                            text: postComunidade,
                            with: viewModelLogin.tokenLogin ?? ""
                        )
                        print("post \(post)")
                    } catch {
                        print("n foi: \(error.localizedDescription)")
                    }
                }
            }) {
                Text("Criar post")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("criar post")
    }
}

