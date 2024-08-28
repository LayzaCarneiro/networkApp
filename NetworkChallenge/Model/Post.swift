import Foundation

struct Post: Decodable {
    let id: UUID
    let text: String
    let user_id: String
    let user: User?
    let media: String?
    let likeCount: Int?
}
