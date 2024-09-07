//
//  RedeSocialApp.swift
//  RedeSocial
//
//  Created by Leticia França on 26/08/24
//

import SwiftUI

@main
struct NetworkChallengeApp: App {
    
    @State private var showSplash: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                            Image("splash5")
                                .resizable()
                                .scaledToFit()
                        }
                    }
            } else {
                LoginView()
            }
        }
    }
}

