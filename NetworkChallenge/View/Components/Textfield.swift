//
//  Textfield.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 28/08/24.
//

import SwiftUI

struct Textfield: View {
    @State var text: String = ""
    @State var field: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                Image("textfield")
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .scaledToFit()
                    .padding()
                
                TextField("\(text)", text: $field)
                    .padding()
                    .padding(.leading, geometry.size.width * 0.03)
                    .padding(.trailing, geometry.size.width * 0.08)
            }
            
        }
    }
}

#Preview {
    Textfield()
}
