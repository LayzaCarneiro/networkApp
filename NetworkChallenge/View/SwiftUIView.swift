//
//  SwiftUIView.swift
//  NetworkChallenge
//
//  Created by Kelly Letícia Nascimento de Morais on 28/08/24.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(0..<5) { _ in
                    Image("Frame")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .padding()
                        .containerRelativeFrame(.horizontal)
                }
                
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
    }
}

#Preview {
    SwiftUIView()
}
