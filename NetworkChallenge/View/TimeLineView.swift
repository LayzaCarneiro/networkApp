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
    //@State private var textCount = ""
    @StateObject var textCount = TextCount()
    
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
                            Image(systemName: "plus")
                                .foregroundColor(.blue)
                                .font(.title.weight(.semibold))
                                .padding(3)
                                .background(Color.white)
                                .clipShape(Rectangle())
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
                        
                        Button {
                            showingSheetCharacter = true
                        } label: {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.blue)
                                .font(.title.weight(.semibold))
                                .padding(3)
                                .background(Color.white)
                                .clipShape(Rectangle())
                        }
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
                    .padding(.leading, 250)
                    
                    ScrollView{
                        PostView(viewModel: viewModel, textCount: textCount)
                    }
                }
                
            }
        }
    }
    
    
}


struct SheetViewPost: View {
    @Environment(\.dismiss) var dismiss
    //@State public var textinput: String
    @State private var characterLimit = 20
    //@ObservedObject var textCount = TextCount()
    @ObservedObject var textCount: TextCount
    
    var body: some View {
        NavigationStack{
            HStack{
                Image("insect_3")
                    .resizable()
                //.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .frame(width: 30, height:60)
                    .padding(.leading)
                TextField("Placeholder", text: $textCount.text, axis: .vertical)
                    .padding()
                    .multilineTextAlignment(.leading)
                    .onChange(of: textCount.text) { _ in
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
                    //.background(Color.purple)
                    
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        //
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
    @StateObject var textCount = TextCount()
    
    var body: some View{
        
        ZStack {
            Image("tree")
                .resizable()
                .scaledToFit()
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
            TextDisplayView(textCount: textCount)
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
        //.padding(.top, -60)
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
