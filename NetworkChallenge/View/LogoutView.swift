//
//  LogoutView.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 10/09/24.
//

import SwiftUI

struct LogoutView: View {
    
    @ObservedObject var viewModelLogin: LoginViewModel
    @State var navFeed = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundOffWhite.ignoresSafeArea()
                
                VStack {
                    
                    Button {
                        Task {
                            try await viewModelLogin.logout(with: viewModelLogin.tokenLogin!)
                            navFeed = true
                        }
                    } label: {
                        Text("Logout")
                            .font(.title1, weight: .semibold)
                    }
                    .navigationDestination(isPresented: $navFeed) {
                        LoginView()
                    }
                    
                }
            }
        }
    }
}

//#Preview {
//    LogoutVieww()
//}
