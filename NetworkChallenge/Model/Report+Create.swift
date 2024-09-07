//
//  Report+Create.swift
//  RedeSocial
//
//  Created by Leticia França on 26/08/24.
//

import Foundation

extension Report {
    struct Create: Encodable {
        let id: UUID
        let reason: String
    }
}
