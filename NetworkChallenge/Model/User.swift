//
//  User.swift
//
//
//  Created by Gabriela Bezerra on 20/08/24.
//

import Foundation

struct User: Decodable, Equatable {
    let id: UUID
    let username: String
    let name: String
    var avatar: String?
}
