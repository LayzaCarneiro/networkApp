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

    var body: some View {
        ZStack {
            Image("\(textfield)")
                .resizable()
                .scaledToFit()
                .frame(width: 190)
                .clipped()
            
            if isSecure {
                SecureField("\(placeholder)", text: $field)
                    .padding(.leading, 65)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .font(.title3)
                
            } else {
                TextField("\(placeholder)", text: $field)
                    .padding(.leading, 65)
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

