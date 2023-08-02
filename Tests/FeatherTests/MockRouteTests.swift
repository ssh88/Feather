import XCTest
import XCTVapor
@testable import Feather

final class MockRouteTests: XCTestCase {
    
    func test_init_json() {
        let route = MockRoute(method: .get,
                              endpoint: "user",
                              code: 200,
                              json: "{\"id\":1,\"name\":\"John Doe\"}")
        let result = try! JSONDecoder().decode(User.self, from: route.json.data(using: .utf8)!)
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.name, "John Doe")
    }
    
//    func test_init_filename() {
//        let route = MockRoute(method: .get,
//                              endpoint: "user",
//                              code: 200,
//                              filename: "user")
//        let result = try! JSONDecoder().decode(User.self, from: route.json.data(using: .utf8)!)
//        XCTAssertEqual(result.id, 1)
//        XCTAssertEqual(result.name, "John Doe")
//    }
    
    func test_init_object() {
        let route = MockRoute(method: .get,
                              endpoint: "user",
                              code: 200,
                              object: User(id: 1, name: "John Doe"))
        let result = try! JSONDecoder().decode(User.self, from: route.json.data(using: .utf8)!)
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.name, "John Doe")
    }
}
