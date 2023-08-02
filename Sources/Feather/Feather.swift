import Foundation
import Vapor

/** TODO's:
 - create addRoute function / start server without routes
 - add unit tests
 - add 400 etc status code UITests to demo
 */

public class Feather {
    
    private let host: String
    private let port: Int
    
    let app: Application
    var mockRouteCollection: MockRouteCollection?
    
    public var baseUrl: String {
        let configuration = app.http.server.configuration
        let scheme = configuration.tlsConfiguration == nil ? "http" : "https"
        let host = configuration.hostname
        let port = configuration.port
        return "\(scheme)://\(host):\(port)"
    }
    
    public init(host: String = "localhost",
                port: Int = 8080,
                environment: Environment = .init(name: "development", arguments: ["vapor"])) {
        self.host = host
        self.port = port
        app = Application(environment)
        configure()
    }
    
    /// Starts a server with provided mock routes
    public func startServer(with routes: [MockRoute]) {
        Logger.shared.debug("Starting server @ \(baseUrl)")
        do {
            try registerMockRouteCollection(with: routes)
            try app.start()
            Logger.shared.debug("Finished creating Routes: \(app.routes.all)")
        } catch {
            Logger.shared.error("Failed to start server", error: error)
        }
    }
    
    /// Shutdown server
    public func pluck() {
        app.server.shutdown()
        app.shutdown()
        Logger.shared.debug("Server shutdown")
    }
}

// MARK: - Update Functions

extension Feather {
    
    /// Updates the response of an existing http method and endpoint with a JSON String
    public func updateRoute(method: MockRoute.HTTPMethod,
                            endpoint: String,
                            json: String) {
        mockRouteCollection?.updateRoute(method: method, endpoint: endpoint, json: json)
    }
    
    /// Updates the response of an existing http method and endpoint with an Encodable object
    public func updateRoute(method: MockRoute.HTTPMethod,
                            endpoint: String,
                            object: Encodable) {
        let json = JSONCoder.encode(object)
        mockRouteCollection?.updateRoute(method: method, endpoint: endpoint, json: json)
    }
    
    /// Updates the response of an existing http method and endpoint with a JSON filename
    public func updateRoute(method: MockRoute.HTTPMethod,
                            endpoint: String,
                            filename: String) {
        let json = JSONCoder.decode(from: filename)
        mockRouteCollection?.updateRoute(method: method, endpoint: endpoint, json: json)
    }
}

// MARK: - Private

private extension Feather {
    func registerMockRouteCollection(with routes: [MockRoute]) throws {
        mockRouteCollection = MockRouteCollection(mockRoutes: routes)
        if let mockRouteCollection {
            try app.register(collection: mockRouteCollection)
        }
    }
    
    func configure() {
        app.http.server.configuration.hostname = host
        app.http.server.configuration.port = port
    }
}

