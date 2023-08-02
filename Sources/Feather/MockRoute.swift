import Foundation

public class MockRoute: Codable {
    
    public enum HTTPMethod: String, Codable {
        case get     = "GET"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
    }
    
    let method: HTTPMethod
    let endpoint: String
    let code: Int
    let filename: String?
    var json: String
    
    /// Create a route from mock file
    public init(method: HTTPMethod,
                endpoint: String,
                code: Int,
                filename: String) {
        self.method = method
        self.endpoint = endpoint
        self.code = code
        self.filename = filename
        self.json = JSONCoder.decode(from: filename)
    }
    
    /// Create a route from JSON string
    public init(method: HTTPMethod,
                endpoint: String,
                code: Int,
                json: String) {
        self.method = method
        self.endpoint = endpoint
        self.code = code
        self.json = json
        self.filename = nil
    }
    
    /// Create a route from an encodable object
    public init(method: HTTPMethod,
                endpoint: String,
                code: Int,
                object: Encodable) {
        self.method = method
        self.endpoint = endpoint
        self.code = code
        self.json = JSONCoder.encode(object)
        self.filename = nil
    }
}
