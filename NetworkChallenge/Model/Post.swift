import Foundation

struct Post: Decodable {
    let id: UUID
    let text: String
    let media: String?
    let likeCount: Int?
    let createdAt: Date?
    let updatedAt: Date?
    let userID: UUID?
}
