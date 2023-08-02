import XCTest
import XCTVapor
@testable import Feather

final class MockRouteCollectionTests: XCTestCase {
    
    var app: Application!
    var feather: Feather!
    
    override func setUp() {
        super.setUp()
        feather = Feather(port: 1000, environment: .testing)
        app = feather.app
    }
    
    override func tearDown() {
        feather.pluck()
        app = nil
        feather = nil
        super.tearDown()
    }
    
    private func route(for method: MockRoute.HTTPMethod) -> MockRoute {
        .init(method: method,
              endpoint: "user",
              code: 200,
              object: User(id: 1, name: "John Doe"))
    }
    
    func test_get() async throws {
        let route = route(for: .get)
        feather.startServer(with: [route])
        
        try app.test(.GET, "user") { res in
            let user = try JSONDecoder().decode(User.self, from: res.body)
            XCTAssertEqual(user.id, 1)
            XCTAssertEqual(user.name, "John Doe")
        }
    }
    
    func test_post() async throws {
        let route = route(for: .post)
        feather.startServer(with: [route])
        
        try app.test(.POST, "user") { res in
            let user = try JSONDecoder().decode(User.self, from: res.body)
            XCTAssertEqual(user.id, 1)
            XCTAssertEqual(user.name, "John Doe")
        }
    }
    
    func test_patch() async throws {
        let route = route(for: .patch)
        feather.startServer(with: [route])
        
        try app.test(.PATCH, "user") { res in
            let user = try JSONDecoder().decode(User.self, from: res.body)
            XCTAssertEqual(user.id, 1)
            XCTAssertEqual(user.name, "John Doe")
        }
    }
    
    func test_put() async throws {
        let route = route(for: .put)
        feather.startServer(with: [route])
        
        try app.test(.PUT, "user") { res in
            let user = try JSONDecoder().decode(User.self, from: res.body)
            XCTAssertEqual(user.id, 1)
            XCTAssertEqual(user.name, "John Doe")
        }
    }
    
    func test_delete() async throws {
        let route = route(for: .delete)
        feather.startServer(with: [route])
        
        try app.test(.DELETE, "user") { res in
            let user = try JSONDecoder().decode(User.self, from: res.body)
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(user.id, 1)
            XCTAssertEqual(user.name, "John Doe")
        }
    }
}
