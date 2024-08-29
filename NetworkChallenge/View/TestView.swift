import SwiftUI

struct TestView: View {
    @StateObject var viewModelPost = PostViewModel()
    
    @State var comunidadeSel: String = ""
    var comunidades: [String] = ["FORMIGAS", "ROBOS", "PADRINHOSMAGICOS"]
    
    var filteredPosts: [Post] {
        if comunidadeSel.isEmpty {
            return viewModelPost.posts
        } else {
            return viewModelPost.posts.filter { post in
                let postComunidade = comunidade(from: post.text)
                return postComunidade == comunidadeSel
            }
        }
    }
    
    func comunidade(from text: String) -> String {
        let components = text.components(separatedBy: "!@#$%ˆ&*")
        return components.first ?? ""
    }
    
    func texto(from text: String) -> String {
        let components = text.components(separatedBy: "!@#$%ˆ&*")
        return components.count > 1 ? components[1] : text
    }
    
    var body: some View {
        VStack {
            Picker("filtrar comunidade", selection: $comunidadeSel) {
                ForEach(comunidades, id: \.self) { comunidade in
                    Text(comunidade).tag(comunidade)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            if viewModelPost.posts.isEmpty {
                Text("Nenhum post encontrado.")
                    .padding()
            } else {
                VStack {
                    List {
                        ForEach(filteredPosts) { post in
                            HStack {
                                VStack {
                                    Image("blusa")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                    HStack (spacing: 1) {
                                        Image(systemName: "heart")
                                            .font(.system(size: 14))
                                            .foregroundStyle(Color.gray)

                                        Text("\(post.like_count ?? 0)")
                                            .font(.system(size: 12))
                                            .foregroundStyle(Color.gray)
                                    }
                                }
                                
                                VStack (alignment: .leading) {
                                    HStack {
                                        Text("\(post.user?.username ?? "")")
                                            .font(.system(size: 14))
                                        Text("há 15 minutos")
                                            .font(.system(size: 14))
                                            .foregroundStyle(Color.gray)
                                    }
                                    Text(texto(from: post.text))
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.gray.opacity(0.2))
                                        )
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            Button(role: .destructive) {
                                            } label: {
                                                Label("Deletar", systemImage: "trash.fill")
                                            }
                                            Button {
                                            } label: {
                                                Label("Reportar", systemImage: "exclamationmark.triangle")
                                            }
                                            .tint(.blue)
                                        }
                                }
                            }
                            .onTapGesture(count: 2) {
                                print("Double tapped!")
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }

            if let errorMessage = viewModelPost.errorMessage {
                Text("Erro: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            Task {
                do {
                    try await viewModelPost.fetchPosts()
                } catch {
                    viewModelPost.errorMessage = "Erro ao carregar posts: \(error.localizedDescription)"
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

#Preview {
    TestView()
}
