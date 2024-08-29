import SwiftUI

struct ComunidadesView: View {
    
    let comunidades = ["a", "b", "c"]
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .onTapGesture {
                    }
            }
            .padding()
            Spacer()
            Text("Para onde você quer viajar?")
                .font(.system(.title, design: .monospaced))
                .multilineTextAlignment(.center)
                .fontWeight(.heavy)
            HStack {
                
                Image(systemName: "chevron.backward")
                Spacer()
                
                TabView {
                    ForEach(comunidades, id: \.self) { item in
                        VStack {
                            VStack {
                                Image("pintura")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 300, height: 300)
                                    .clipped()
                                    .cornerRadius(10)
                            }
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(.black, lineWidth: 1.5)
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(1))
                                    .offset(x: 5, y: 5)
                            )
                            
                            Spacer()
                                .frame(height: 50)
                            
                            VStack {
                                
                                
                                Text("Nome da comunidade")
                                    .font(.system(.body, design: .monospaced))

                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)

                                
                            }
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(.black, lineWidth: 1.5)
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(1))
                                    .offset(x: 5, y: 5)
                            )
                            
                            
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 500)
                Spacer()
                Image(systemName: "chevron.forward")


            }
            .padding()
            Spacer()

        }
        .background(
            Image("fundo")
                .opacity(0.4)
        )
        .background(Color.gray.opacity(0.1))

        
    }
}

#Preview {
    ComunidadesView()
}
