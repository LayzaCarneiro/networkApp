//
//  TextDisplayView.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 10/09/24.
//

import SwiftUI

class TextCount: ObservableObject {
    @Published var counted = "0/120"
    @Published var text = "" {
        didSet {
            counted = String("\(text.count)/120")
        }
    }
}

struct TextDisplayView: View {
    @ObservedObject var textCount: TextCount
    
    var body: some View {
        Text(textCount.text.isEmpty ? "" : textCount.text)
            .padding()
            .font(.body)
    }
}


//#Preview {
//    TextDisplayView()
//}
