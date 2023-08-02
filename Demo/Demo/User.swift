import Foundation

struct User: Codable, Identifiable {
    var id: Int
    var name: String
    var username: String?
    var email: String?
}

#if DEBUG
/// Mock data to be used in preview providers, unit & ui tests
extension User {
    static func mock(id: Int = 0,
                     name: String = "John Doe",
                     username: String? = "JohnD",
                     email: String? = "john.doe@email.com") -> Self {
        Self(id: id,
             name: name,
             username: username,
             email: email)
    }
}
#endif
