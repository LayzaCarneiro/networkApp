import Foundation

struct Post: Decodable, Identifiable {
    let id: UUID
    let text: String
    let user_id: String
    let user: User?
    let media: String?
    let like_count: Int?
//    let created_at: Date
//    let updated_at: Date?
}
