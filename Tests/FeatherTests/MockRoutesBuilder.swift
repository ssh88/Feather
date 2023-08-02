import Foundation
import Vapor

class MockRoutesBuilder: RoutesBuilder {
    
    var routes: [Vapor.Route] = []
    
    func add(_ route: Vapor.Route) {
        routes.append(route)
    }
}
