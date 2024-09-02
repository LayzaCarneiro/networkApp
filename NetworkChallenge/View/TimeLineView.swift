//
//  TimeLineView.swift
//  NetworkChallenge
//
//  Created by Raynara Coelho on 27/08/24.

import Foundation
import SwiftUI

struct TimeLineView: View {
    @State private var showingSheetPost = false
    @State private var showingSheetCharacter = false
    @State private var isLiked = false
    @StateObject private var viewModel = CharacterViewModel()
    @StateObject var textCount = TextCount()
    
    @StateObject var viewModelPost = PostViewModel()
    @ObservedObject var viewModelReport = ReportViewModel()

    @State var comunidadeSel: String = "FORMIGAS"
    var comunidades: [String] = ["FORMIGAS", "ROBOS", "PADRINHOSMAGICOS"]
    
    var filteredPosts: [Post] {
        if comunidadeSel.isEmpty {
            return viewModelPost.posts
        } else {
            return viewModelPost.posts.filter { post in
                let postComunidade = comunidade(from: post.text)
                return postComunidade == comunidadeSel
            }
        }
    }
    
    func comunidade(from text: String) -> String {
        let components = text.components(separatedBy: "!@#$%ˆ&*")
        return components.first ?? ""
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background_insects")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button {
                            showingSheetPost = true
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                            //.frame(width: 80, height:150)
                                .scaledToFill()
                                .foregroundColor(.yellow)
                                //.rotationEffect(.degrees(30.0))
                        }
                        
                        .sheet(isPresented: $showingSheetPost) {
                            NavigationStack {
                                ZStack{
                                    Color("skyblue")
                                        .ignoresSafeArea()
                                        //.resizable()
                                        //.scaledToFill()
                                    SheetViewPost( textCount: textCount, viewModel: viewModel)
                                }
                            }
                            .presentationDetents([.height(250)])
                            .presentationDragIndicator(.hidden)
                            //.background(Color.blue)
                            
                        }
                        //.padding(.leading, 250)
                        Button {
                            showingSheetCharacter = true
                        } label: {
                            Image( systemName: "ladybug.circle.fill")
                                .resizable()
                            //.frame(width: 80, height:150)
                                .scaledToFill()
                                .foregroundColor(.purple)
                                .rotationEffect(.degrees(30.0))
                        }
                        //.padding(.top, 10)
                        .sheet(isPresented: $showingSheetCharacter) {
                            ZStack{
                                Color("skyblue")
                                    .ignoresSafeArea()
//                                    .resizable()
//                                    .scaledToFill()
                                SheetViewCharacter( viewModel: viewModel)
                                    .presentationDetents([.medium])
                                    .presentationDragIndicator(.hidden)
                            }
                        }
                    }
                    .frame(width: 100, height: 40)
                    .padding(.leading, 250)
                    //.padding(.bottom, 0)
                    ScrollView {
//                        PostView(viewModel: viewModel, textCount: textCount)
                        ForEach(viewModelPost.posts) { post in
                            PostView(viewModel: viewModel, textCount: textCount, text: post.text)
//                            Text(post.text)
                        }
                    }
                }
                .onAppear {
                    Task {
                        do {
                            try await viewModelPost.fetchPosts()
//                            try await viewModelUser.fetchUsers()
                        } catch {
                            viewModelPost.errorMessage = "erro carregar posts: \(error.localizedDescription)"
                        }
                    }
                }
            }
        }
    }
}


struct SheetViewPost: View {
    @Environment(\.dismiss) var dismiss
    @State private var characterLimit = 150
    @ObservedObject var textCount: TextCount
    @ObservedObject var viewModel: CharacterViewModel
    
    var body: some View {
        NavigationStack{
                ZStack {
//                    Rectangle()
//                        .foregroundColor(.white)
//                        .opacity(0.6)
                    HStack {
                        if let character = viewModel.selectedCharacter {
                            Image(character)
                                .resizable()
                                .frame(width: 30, height:60)
                                //.padding(.trailing, 300)
                                //.padding(.bottom, 200)
                        }
                        TextField("O que está acontecendo?", text: $textCount.text, axis: .vertical)
//                            .padding(.leading, 20)
//                            .padding(.bottom, 100)
                            .multilineTextAlignment(.leading)
                            .onChange( of: textCount.text) { _ in
                                textCount.text = String(textCount.text.prefix(characterLimit))
                            }
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 80)
                    Text("\(textCount.counted)")
                        .foregroundColor(.white)
                        .padding(.top, 200)
                        .padding(.leading, 250)
                    
                }
                .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(.white, lineWidth: 2)
                   )
                .padding()


            
        }
        Spacer()
            .toolbar{
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        sendText(textCount.text)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .foregroundColor(.white)
    }
}

struct SheetViewCharacter: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CharacterViewModel
    
    var body: some View {
        VStack{
            Text("Select character")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.white)

            VStack{
                
                HStack{
                        Button(action: { viewModel.selectedCharacter = "insect_1" }) {
                            Image("insect_1")
                                .resizable()
                                .frame(width: 80, height:150)
                        }
                    Button(action: {viewModel.selectedCharacter = "insect_2"}) {
                        Image("insect_2")
                            .resizable()
                            .frame(width: 80, height:150)
                    }
                    .padding(.leading, 50)
                }
                
                HStack{
                    Button(action: {viewModel.selectedCharacter = "insect_3"}) {
                        Image("insect_3")
                            .resizable()
                            .frame(width: 80, height:150)
                    }
                    Button(action: {viewModel.selectedCharacter = "insect_4"}) {
                        Image("insect_4")
                            .resizable()
                            .frame(width: 80, height:150)
                        //.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    }
                    .padding(.leading, 50)
                }
            }
            Button("Press to dismiss") {
                dismiss()
            }
            .foregroundStyle(.white)
        }
    }
}

class CharacterViewModel: ObservableObject {
    @Published var selectedCharacter: String? = nil
}

struct PostView: View {
    @State private var isLiked = false
    @ObservedObject var viewModel: CharacterViewModel
    @ObservedObject var textCount: TextCount
    @State var text: String = ""
    
    var body: some View{
        
        ZStack {
            Image("tree")
                .resizable()
                .scaledToFill()
                .padding(.bottom, -400)
            Image("whitecloud2")
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 330)
                .padding(.top, 50)
                .padding(.leading, 70)
                .foregroundColor(.white)
                .opacity(0.6)
            
            if let character = viewModel.selectedCharacter {
                Image(character)
                    .resizable()
                    .frame(width: 45, height: 90)
                    .padding(.leading)
                    .padding(.top, 200)
                    .rotationEffect(.degrees(130.0))
            }
          
//             TextDisplayView(textCount: textCount)
//                 .frame(width: 300, height: 330)
//                 .padding(.top, 40)
//                 .padding(.leading, 80)
                //.foregroundColor(.white)
                        
            Text(text)
                .padding(.leading, 120)
                .padding(.trailing, 70)

            
            Button {
                self.isLiked.toggle()
            } label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 230)
                    .padding(.leading, 300)
            }
        }
        .padding(.top, -60)
    }
}

class TextCount: ObservableObject {
    @Published var counted = "0/150"
    @Published var text = "" {
        didSet {
            counted = String("\(text.count)/150")
        }
    }
}

struct TextDisplayView: View {
    @ObservedObject var textCount: TextCount
    
    var body: some View {
        Text(textCount.text.isEmpty ? "" : textCount.text)
            .padding()
    }
}

func sendText(_ text: String) {
    print("Texto enviado: \(text)")
}

#Preview {
    TimeLineView()
}
