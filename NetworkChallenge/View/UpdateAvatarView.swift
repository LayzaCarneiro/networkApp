//
//  UpdateAvatarView.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 26/08/24.
//

import SwiftUI
import PhotosUI


struct UpdateAvatarView: View {
    
    @ObservedObject var viewModelUser = UserViewModel()
    @State var uiImage: UIImage? = nil
    @State var imageSelection: PhotosPickerItem? = nil
    
    var body: some View {
        
        VStack {
            
            if let user = viewModelUser.users.first {
                Text(user.name)
                Text(user.username)
                
                Image(uiImage: UIImage(named: "defaultAvatar") ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipped()
                    .background(Color.gray.opacity(0.2))
                
                Button(action: {
//                    viewModelUser.updateAvatar(user: user)
                }) {
                    Text("Atualizar Avatar com Imagem Padrão")
                }
                
                if let errorMessage = viewModelUser.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            Task {
                await viewModelUser.fetchUsers()
            }
        }
        .onChange(of: imageSelection) {
            Task { @MainActor in
                if let data = try? await imageSelection?.loadTransferable(type: Data.self) {
                    uiImage = UIImage(data:data)
                    return
                }
            }
        }
    }
    
    var photoPickerButton: some View {
        PhotosPicker(
          selection: $imageSelection,
          matching: .images,
          photoLibrary: .shared()) {
            Image(systemName: "camera.circle.fill")
              .font(.system(size: 50))
              .foregroundColor(.gray)
          }
      }
}

#Preview {
    UpdateAvatarView()
}
