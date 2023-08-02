import Foundation

struct User: Codable, Identifiable {
    var id: Int
    var name: String
    var username: String?
    var email: String?
}
