//
//  loginTicket.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 29/08/24.
//

import SwiftUI

struct LoginTicket: View {
    @State var placeholder: String = ""
    @State var textfield: String = "textfield"
    @Binding var field: String
    
    var isSecure: Bool = false

    @State var paddingLeading: CGFloat = 70
    @State var frameTextfield: CGFloat = 190
    
    var body: some View {
        ZStack {
            Image("\(textfield)")
                .resizable()
                .scaledToFit()
                .frame(width: frameTextfield)
                .clipped()
            
            if isSecure {
                SecureField("\(placeholder)", text: $field)
                    .padding(.leading, paddingLeading)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .font(.title3)
                
            } else {
                TextField("\(placeholder)", text: $field)
                    .padding(.leading, paddingLeading)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .font(.title3)
            }
        }
    }
}

//#Preview {
//    LoginTicket()
//}

