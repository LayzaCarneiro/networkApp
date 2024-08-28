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
                            SheetViewPost( textinput: "")
                                .presentationDetents([.medium, .large])
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
                                SheetViewCharacter( )
                                    .presentationDetents([.medium])
                                    .presentationDragIndicator(.hidden)
                            }
                                
                        }
                    }
                    .padding(.leading, 250)
                    
                    ScrollView{
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
                            Text("teste")
                        }
                        .padding(.top, 60)
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
                            Text("teste")
                        }
                        .padding(.top, -60)
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
                            Text("teste")
                        }
                        .padding(.top, -60)
                        
                    }
                }
        
            }
        }
    }
    
}


struct SheetViewPost: View {
    @Environment(\.dismiss) var dismiss
    @State public var textinput: String

    var body: some View {
        VStack{
            TextField("Enter your name", text: $textinput, axis: .vertical)
                .frame(width: 300, height: 100)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button("Press to dismiss") {
                dismiss()
            }
        }
    }
}

struct SheetViewCharacter: View {
    @Environment(\.dismiss) var dismiss
    //@State public var textinput: String

    var body: some View {
        VStack{
            Text("Select character")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            VStack{
                HStack{
                    Button(action: {}) {
                        Image("insect_1")
                            .resizable()
                            .frame(width: 80, height:150)
                    }
                    Button(action: {}) {
                        Image("insect_2")
                            .resizable()
                            .frame(width: 80, height:150)
                    }
                    .padding(.leading, 50)
                }
                
                HStack{
                    Button(action: {}) {
                        Image("insect_3")
                            .resizable()
                            .frame(width: 80, height:150)
                    }
                    Button(action: {}) {
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


#Preview {
    TimeLineView()
}
