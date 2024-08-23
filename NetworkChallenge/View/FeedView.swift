//
//  FeedView.swift
//  NetworkApp
//
//  Created by Leticia França on 23/08/24.
//

import SwiftUI

struct FeedView: View {
    var user: User

    var body: some View {
        VStack {
            Text("nome do usuario autenticado: \(user.username)!")
                .font(.largeTitle)
                .padding()
        }
    }
}

//#Preview {
//    FeedView()
//}
