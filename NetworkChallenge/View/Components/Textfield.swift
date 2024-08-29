//
//  Textfield.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 28/08/24.
//

import SwiftUI

struct Textfield: View {
    @State var placeholder: String = ""
    @State var field: String = ""
    
    var body: some View {
            ZStack {

                VStack {
                    Spacer()
                    Image("textfield")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)

                    Spacer()
                }

                TextField("\(placeholder)", text: $field)
        
            }
            
        
    }
}

#Preview {
    Textfield()
}
