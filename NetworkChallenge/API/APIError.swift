//
//  APIError.swift
//  NetworkChallenge
//
//  Created by Layza Maria Rodrigues Carneiro on 22/08/24.
//

import Foundation

enum APIError: Error {
    case apiError(code: Int, body: Data?)
}
