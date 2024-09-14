//
//  ReportViewModel.swift
//  RedeSocial
//
//  Created by Leticia França on 26/08/24.
//

import Foundation

class ReportViewModel: ObservableObject {
    @Published var reports: [Report] = []

    @Published var posts: [Post] = []
    @Published var user: User?
    @Published var tokenLogin: String?
    
    let baseURL = URL(string: "http://127.0.0.1:8080")!

    func check(data: Data?, response: URLResponse) throws {
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200..<300:
                print("😸 Sucesso! \(response.statusCode)")
            default:
                print("🙀 Erro \(response.statusCode)")
                throw APIError.apiError(code: response.statusCode, body: data)
            }
        }
    }
    
    func fetchReports(postID: UUID) async {
        do {
            let reports = try await API.searchReports( postID: postID)
            DispatchQueue.main.async {
                self.reports = reports
            }
        } catch {
            DispatchQueue.main.async {
                print("erro pegando reports: \(error)")
            }
        }
    }
}
