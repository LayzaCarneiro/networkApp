//
//  SheetViewPost.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 10/09/24.
//

import SwiftUI

struct SheetViewPost: View {
    @Environment(\.dismiss) var dismiss
    @State private var characterLimit = 120
    @ObservedObject var textCount: TextCount
    @ObservedObject var viewModel: CharacterViewModel
    
    @StateObject var viewModelLogin = LoginViewModel()
    @StateObject var viewModelPost = PostViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    
                    HStack {
                        if let character = viewModel.selectedCharacter {
                            Image(character)
                                .resizable()
                                .frame(width: 30, height:60)
                        }
                        
                        TextField("O que está acontecendo?", text: $textCount.text, axis: .vertical)
                            .multilineTextAlignment(.leading)
                            .onChange( of: textCount.text) { _ in
                                textCount.text = String(textCount.text.prefix(characterLimit))
                            }
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 80)
                    Text("\(textCount.counted)")
                        .foregroundColor(.white)
                        .padding(.top, 200)
                        .padding(.leading, 250)
                    
                }
                .overlay( RoundedRectangle(cornerRadius: 14) .stroke(.white, lineWidth: 2))
                .padding()
            }
            
            Spacer()
            
                .toolbar{
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            Task {
                                do {
                                    print("comunidade selecionada formigas")
                                    let postComunidade = "FORMIGAS!@#$%ˆ&*\(textCount.text)"
                                    let post = try await viewModelPost.createPost(
                                        text: postComunidade,
                                        with: viewModelLogin.tokenLogin ?? ""
                                    )
                                    print("post \(post)")
                                } catch {
                                    print("n foi: \(error.localizedDescription)")
                                }
                                await viewModelPost.fetchPosts()
                                dismiss()
                            }
                        } label: {
                            Text("Post")
                                .font(.title3)
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .font(.title3)
                        }
                    }
                }
                .foregroundColor(.white)
        }
    }
}
