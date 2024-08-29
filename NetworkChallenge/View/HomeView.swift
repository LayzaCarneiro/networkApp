//
//  HomeView.swift
//  NetworkChallenge
//
//  Created by Kelly Letícia Nascimento de Morais on 27/08/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(0..<2) { _ in
                        VStack {
                            Image("Frame")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                            
                            Image("FrameName")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 100)
                        }
                        .padding()
                        .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
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
                        Image("ExitButton")
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
}

#Preview {
    HomeView()
}
