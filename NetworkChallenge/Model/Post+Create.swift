//
//  Post+Create.swift
//  NetworkApp
//
//  Created by Leticia França on 22/08/24.
//

import Foundation

extension Post {
    struct Create: Encodable {
        let text: String
        let media: String?
        let likeCount: Int?
        let createdAt: Date?
        let updatedAt: Date?
        let userID: UUID
    }
}
