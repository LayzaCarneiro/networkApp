//
//  SheetViewCharacter.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 10/09/24.
//

import SwiftUI

struct SheetViewCharacter: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CharacterViewModel
    
    @Binding var insetoSelecionado: String
    @State var avatarURL: URL?
    @StateObject var viewModelUser = UserViewModel()
    @StateObject var viewModelLogin = LoginViewModel()
    
    let avatarInsetos = ["insect_1", "insect_2", "insect_3", "insect_4"]
    
    var body: some View {
        VStack {
            Text("Selecione seu avatar")
                .font(.title2, weight: .bold)
                .foregroundStyle(.white)
            
            VStack {
                ForEach(0..<avatarInsetos.count) { index in
                    Button {
                        dismiss()
                    } label: {
                        Image(avatarInsetos[index])
                            .resizable()
                            .frame(width: 50, height: 75)
                            .onTapGesture {
                                insetoSelecionado = avatarInsetos[index]
                                Task {
                                    do {
                                        if let avatarData = UIImage(named: avatarInsetos[index])?.pngData() {
                                            try await viewModelUser.patchAvatar(with: viewModelLogin.tokenLogin!, with: avatarData)
                                            
                                            DispatchQueue.main.async {
                                                viewModelLogin.user?.avatar = avatarInsetos[index]
                                                avatarURL = URL(string: "\(API.baseURL)/\(avatarInsetos[index])")
                                            }
                                        }
                                    } catch {
                                        print("erro avatar: \(error)")
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
}
