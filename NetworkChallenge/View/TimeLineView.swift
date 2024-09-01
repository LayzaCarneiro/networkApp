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
                            Image("pencil")
                                .resizable()
                            //.frame(width: 80, height:150)
                                .scaledToFill()
                                .rotationEffect(.degrees(30.0))
                        }
                        
                        .sheet(isPresented: $showingSheetPost) {
                            NavigationStack {
                                ZStack{
                                    Image("background_insects")
                                        .resizable()
                                        .scaledToFill()
                                    SheetViewPost( textCount: textCount)
                                }
                            }
                            .presentationDetents([.height(250)])
                            .presentationDragIndicator(.hidden)
                            
                        }
                        //.padding(.leading, 250)
                        Button {
                            showingSheetCharacter = true
                        } label: {
                            Image( "spiderweb")
                                .resizable()
                            //.frame(width: 80, height:150)
                                .scaledToFill()
                                .rotationEffect(.degrees(30.0))
                        }
                        .padding(.top, 10)
                        .sheet(isPresented: $showingSheetCharacter) {
                            ZStack{
                                Image("background_insects")
                                    .resizable()
                                    .scaledToFill()
                                SheetViewCharacter( viewModel: viewModel)
                                    .presentationDetents([.medium])
                                    .presentationDragIndicator(.hidden)
                            }
                        }
                    }
                    .frame(width: 200, height: 150)
                    .padding(.leading, 150)
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
    @State private var characterLimit = 20
    @ObservedObject var textCount: TextCount
    
    var body: some View {
        NavigationStack{
            HStack{
                Image("insect_3")
                    .resizable()
                    .frame(width: 30, height:60)
                    .padding(.leading)
                TextField("Placeholder", text: $textCount.text, axis: .vertical)
                    .padding()
                    .multilineTextAlignment(.leading)
                    .onChange( of: textCount.text) { _ in
                        textCount.text = String(textCount.text.prefix(characterLimit))
                    }
                
            }
            Text("\(textCount.counted)")
                .foregroundColor(.gray)
                .padding(.top)
            
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
    }
}

struct SheetViewCharacter: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CharacterViewModel
    
    var body: some View {
        VStack{
            Text("Select character")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
            Rectangle()
                .frame(width: 250, height: 150)
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
                        
//            TextDisplayView(textCount: textCount)
            Text(text)
                .padding(.leading, 120)
                .padding(.trailing, 70)

            
            Button {
                self.isLiked.toggle()
            } label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                    .padding(.top, 100)
                    .padding(.leading, 250)
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
