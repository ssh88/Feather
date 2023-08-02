import Foundation

struct MockAPIClient: APIClientProvider {
    func data(for endpoint: Endpoint) async throws -> Data {
        switch endpoint {
            
        case .user:
            return try JSONEncoder().encode(User.mock())
        case .users:
            return try JSONEncoder().encode([User.mock(id: 0), User.mock(id: 1, name: "Jane Doe")])
        }
    }
}
