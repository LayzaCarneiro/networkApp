//
//  Session.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 22/08/24.
//

import Foundation

struct Session: Decodable {
    let token: String
    let user: User
}
