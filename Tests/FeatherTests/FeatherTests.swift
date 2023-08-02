import XCTest
import XCTVapor
@testable import Feather

final class FeatherTests: XCTestCase {
    
    var app: Application!
    var feather: Feather!
    var userRoute: MockRoute!
    
    override func setUp() {
        super.setUp()
        feather = Feather(port: 1000, environment: .testing)
        app = feather.app
        
        // setup routes
        userRoute = .init(method: .get,
                          endpoint: "user",
                          code: 200,
                          object: User(id: 1, name: "John Doe"))
        let routes: [MockRoute] = [userRoute]
        let mockRouteCollection = MockRouteCollection(mockRoutes: routes)
        feather.mockRouteCollection = mockRouteCollection
        
        // boot routes
        try? mockRouteCollection.boot(routes: MockRoutesBuilder())
    }
    
    override func tearDown() {
        feather.pluck()
        app = nil
        feather = nil
        userRoute = nil
        super.tearDown()
    }
    
    // MARK: - updateRoute
    
    func test_updateRoute_json() {
        feather.updateRoute(method: .get,
                            endpoint: "user",
                            json: "{\"id\":1,\"name\":\"Jane Doe\"}")
        
        XCTAssertEqual(userRoute.json, "{\"id\":1,\"name\":\"Jane Doe\"}")
    }
    
    func test_updateRoute_object() {
        feather.updateRoute(method: .get,
                            endpoint: "user",
                            object: User(id: 1, name: "Jane Doe"))
        
        XCTAssertEqual(userRoute.json, "{\"id\":1,\"name\":\"Jane Doe\"}")
    }
    
//    func test_updateRoute_filename() {
//        feather.updateRoute(method: .get,
//                            endpoint: "user",
//                            filename: "user_updated")
//        
//        let result = try! JSONDecoder().decode(User.self, from: userRoute.json.data(using: .utf8)!)
//        XCTAssertEqual(result.name, "Jane Doe")
//    }
    
    func test_updateRoute_notFound() {
        feather.updateRoute(method: .get,
                            endpoint: "unknown",
                            json: "{\"id\":1,\"name\":\"Jane Doe\"}")
        
        let result = try! JSONDecoder().decode(User.self, from: userRoute.json.data(using: .utf8)!)
        XCTAssertEqual(result.name, "John Doe")
    }
}
