//
//  User.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 22/08/24.
//

import Foundation

struct User: Codable {
    let id: UUID
    let username: String
    let name: String
    let avatar: String?
}
