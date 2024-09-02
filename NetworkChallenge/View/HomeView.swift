import SwiftUI

struct HomeView: View {
    @State var isAceso: Bool = false
    @ObservedObject var viewModelLogin: LoginViewModel
    @StateObject var viewModelPost = PostViewModel()
    @State var navFeed = false
    
    @State var comunidadeSel: String = ""

    let comunidades: [String: String] = [
        "Somos humanos. Não robôs.": "fundo",
        "Vida de inseto": "fundo"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(isAceso ? "backgroundAceso" : "background")
                    .resizable()
                    .scaledToFill()
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
                                    
//                                    if key != comunidades.keys.sorted().first {
//                                        Image("chevron")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 20)
//                                            .padding(.leading, 15)
//                                            .padding(.trailing, -40)
//                                            .allowsHitTesting(false)
//                                    }
                                    
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
                                                        .frame(width: 300, height: 100)
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
                                    }
                                    
//                                    if key != comunidades.keys.sorted().last {
//                                        Image("chevron")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 20)
//                                            .padding(.leading, -40)
//                                            .allowsHitTesting(false)
//                                    }
                                }
                            }
                        }
                        .scrollTargetLayout()
                        .scrollTargetBehavior(.paging)
                        
                        
                    }
                    
                }
                
                VStack {
                    HStack {
                        Button(action: {
                            print("Botão esquerdo pressionado")
                        }) {
                            Image("SearchButton")
                                .resizable()
                                .frame(width: 100, height: 80)
                                .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                        
                        Button {
                            Task {
                                try await viewModelLogin.logout(on: viewModelLogin.baseURL, with: viewModelLogin.tokenLogin!)
                                navFeed = true
                                
                            }
                        } label: {
                            Image("ConfigButton")
                                .resizable()
                                .frame(width: 100, height: 80)
                                .padding()
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
