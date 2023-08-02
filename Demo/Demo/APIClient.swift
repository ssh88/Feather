import Foundation

enum Endpoint: String {
    case user
    case users
}

protocol APIClientProvider {
    func data(for endpoint: Endpoint) async throws -> Data
}

struct APIClient: APIClientProvider {
    
    private var baseUrl: String {
        return ProcessInfo.processInfo.environment["baseUrl"] ?? "https://www.ssh88.co/api/feather"
    }
    
    func data(for endpoint: Endpoint) async throws -> Data {
        let request = request(for: endpoint)
        return try await URLSession.shared.data(for: request).0
    }
    
    private func request(for endpoint: Endpoint) -> URLRequest {
        let url = URL(string: "\(baseUrl)/\(endpoint.rawValue)")!
        return URLRequest(url: url)
    }
}

extension Data {
    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        try JSONDecoder().decode(T.self, from: self)
    }
}
