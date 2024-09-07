import SwiftUI

struct HomeView: View {
    @State var isAceso: Bool = false
    @ObservedObject var viewModelLogin: LoginViewModel
    @StateObject var viewModelPost = PostViewModel()
    @State var navFeed = false
    
    @State var comunidadeSel: String = ""

    let comunidades: [String: String] = [
        "Somos humanos. Não robôs.": "robo",
        "Vida de inseto": "inseto"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(isAceso ? "backgroundAceso" : "background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                }
                .background(Image("")
                    .resizable()
                    .frame(width: 100, height: 100))
                .padding(.top, -350)
                .onTapGesture {
                    isAceso.toggle()
                }
                
                HStack {
                    HStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(comunidades.keys.sorted(), id: \.self) { key in
                                    
                                    VStack {
                                        NavigationLink(destination: TimeLineView(viewModelLogin: viewModelLogin)) {
                                            VStack {
                                                Image("Frame")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 300)
                                                    .background(
                                                        Image(comunidades[key]!)
                                                            .resizable()
                                                            .frame(width: 200, height: 200)
                                                    )
                                                ZStack {
                                                    Image("FrameName")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 330, height: 120)
                                                    Text(key)
                                                        .font(.body)
                                                        .foregroundColor(.black)
                                                        .fontWeight(.semibold)
                                                        .frame(width: 180)
                                                }
                                            }
                                            .padding()
                                            .containerRelativeFrame(.horizontal)
                                        }
                                        .disabled(key == "Somos humanos. Não robôs.")
                                    }
                                }
                            }
                        }
                        .scrollTargetLayout()
                        .scrollTargetBehavior(.paging)
                        
                        
                    }
                    
                }
                
                VStack {
                    HStack {
                        Button {
                            print("Botão esquerdo pressionado")
                        } label: {
                            Image("SearchButton")
                                .resizable()
                                .frame(width: 60, height: 55)
                                .padding(.leading, 25)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                        
                        Button {
                            Task {
                                try await viewModelLogin.logout(with: viewModelLogin.tokenLogin!)
                                navFeed = true
                                
                            }
                        } label: {
                            Image("ConfigButton")
                                .resizable()
                                .frame(width: 60, height: 55)
                                .padding(.trailing, 25)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .navigationDestination(isPresented: $navFeed) {
                            LoginView()
                        }
                    }
                    Spacer()
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    HomeView(viewModelLogin: LoginViewModel())
}
