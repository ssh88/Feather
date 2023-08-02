import XCTest
import Feather

final class DemoUITests: XCTestCase {
    
    var app: XCUIApplication!
    var feather: Feather!
    
    override func setUp() {
        super.setUp()
        feather = Feather(port: 8080)
        app = XCUIApplication()
        app.launchEnvironment["baseUrl"] = feather.baseUrl
    }
    
    override func tearDown() {
        feather.pluck()
        feather = nil
        app = nil
        super.tearDown()
    }
    
    /// Test can create a mock route's json from a string
    func test_mockRoute_jsonString() throws {
        let jsonString = """
        [{
                "id": 1,
                "name": "John Doe"
            },
            {
                "id": 2,
                "name": "Jane Doe"
            }
        ]
        """
        
        let routes: [MockRoute] = [.init(method: .get,
                                         endpoint: "users",
                                         code: 200,
                                         json: jsonString)]
        
        feather.startServer(with: routes)
        app.launch()
        
        XCTAssertEqual(app.staticTexts["name"].firstMatch.label, "John Doe")
    }
    
    /// Test can create a mock route's json from an encodable object
    func test_mockRoute_object() throws {
        let routes: [MockRoute] = [.init(method: .get,
                                         endpoint: "users",
                                         code: 200,
                                         object: [User.mock(id: 1, name: "John Doe"),
                                                  User.mock(id: 2, name: "Jane Doe")])]
        
        feather.startServer(with: routes)
        app.launch()
        
        XCTAssertEqual(app.staticTexts["name"].firstMatch.label, "John Doe")
    }
    
    /// Test can create a mock route's json from a file
    func test_mockRoute_filename() throws {
        let routes: [MockRoute] = [.init(method: .get,
                                         endpoint: "users",
                                         code: 200,
                                         filename: "get_users_200")]
        
        feather.startServer(with: routes)
        app.launch()
        
        XCTAssertEqual(app.staticTexts["name"].firstMatch.label, "John Doe")
    }
    
    /// Test ability to dynamically change response of a route
    func test_updateRoute() throws {
        let routes: [MockRoute] = [.init(method: .get,
                                         endpoint: "users",
                                         code: 200,
                                         object: [User.mock(id: 1, name: "John Doe"),
                                                  User.mock(id: 2, name: "Jane Doe")])]
        
        feather.startServer(with: routes)
        app.launch()
        
        XCTAssertEqual(app.staticTexts["name"].firstMatch.label, "John Doe")
        
        feather.updateRoute(method: .get, endpoint: "users", object: [User.mock(id: 1, name: "Walter White")])
        app.buttons["refresh-button"].tap()
        
        XCTAssertEqual(app.staticTexts["name"].firstMatch.label, "Walter White")
    }
    
    /// Test multiple routes across multple views
    func test_multipleRoutes() throws {
        let routes: [MockRoute] = [.init(method: .get,
                                         endpoint: "users",
                                         code: 200,
                                         object: [User.mock(id: 1, name: "John Doe"),
                                                  User.mock(id: 2, name: "Jane Doe")]),
                                   .init(method: .get,
                                         endpoint: "user",
                                         code: 200,
                                         object: User.mock(id: 1, name: "John Doe"))]
        
        feather.startServer(with: routes)
        app.launch()
        
        let userCard = app.staticTexts["name"].firstMatch
        XCTAssertEqual(userCard.label, "John Doe")
        
        userCard.tap()
        
        let name = app.staticTexts["name"]
        XCTAssertEqual(name.label, "John Doe")
        
        let username = app.staticTexts["username"]
        XCTAssertEqual(username.label, "JohnD")
        
        let email = app.staticTexts["email"]
        XCTAssertEqual(email.label, "john.doe@email.com")
    }
}
