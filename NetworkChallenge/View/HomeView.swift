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
        NavigationView {
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
                
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(comunidades.keys.sorted(), id: \.self) { key in
                                NavigationLink(destination: TimeLineView()) {
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
                                                .font(.system(.body, design: .monospaced))
                                                .foregroundColor(.black)
                                                .fontWeight(.heavy)
                                                .frame(width: 200)
                                        }
                                    }
                                    .padding()
                                    .containerRelativeFrame(.horizontal)
                                }
                            }
                        }
                    }
                    .scrollTargetLayout()
                    .scrollTargetBehavior(.paging)
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
                        
                        Button(action: {
                            print("Botão direito pressionado")
                        }) {
                            Image("ConfigButton")
                                .resizable()
                                .frame(width: 100, height: 80)
                                .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
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
