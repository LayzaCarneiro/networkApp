//
//  SplashView.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 05/09/24.
//

import SwiftUI

struct SplashView: View {
    
    @State private var images: [String] = ["splash1", "splash2", "splash3", "splash4", "splash5"]
    @State private var index: Int = 0
    @State private var timer: Timer?

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
            index = (index + 1) % images.count
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    var body: some View {
        VStack {
            Image(images[index])
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: startTimer)
        .onDisappear(perform: stopTimer)
    }
}

#Preview {
    SplashView()
}
