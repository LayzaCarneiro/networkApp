//
//  LoginView.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 27/08/24.
//

import SwiftUI

struct LoginView: View {
    @State var name: String = ""
    
    var body: some View {
        ZStack {
            
            Color.backgroundOffWhite.ignoresSafeArea()
            
            Textfield(text: "Usuário", field: name)
            
        }
    }
}

#Preview {
    LoginView()
}
