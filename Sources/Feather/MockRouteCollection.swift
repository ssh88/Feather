import Vapor

class MockRouteCollection: RouteCollection {

    var mockRoutes: [MockRoute]
    
    init(mockRoutes: [MockRoute]) {
        self.mockRoutes = mockRoutes
    }
    
    func boot(routes: RoutesBuilder) throws {
        for route in mockRoutes {
            Logger.shared.debug("Creating mock route: \(route.code) \(route.method.rawValue) - \(route.endpoint)")
            configureRoutes(routes, with: route)
        }
    }
    
    func updateRoute(method: MockRoute.HTTPMethod,
                     endpoint: String,
                     json: String) {
        mockRoutes.forEach { route in
            guard route.method == method && route.endpoint == endpoint else { return }
            Logger.shared.debug("Updating JSON for \(route.code) \(route.method.rawValue) - \(route.endpoint)")
            route.json = json
        }
    }
    
    private func configureRoutes(_ routes: RoutesBuilder, with route: MockRoute) {
        let endpoint = route.endpoint
        switch route.method {
        case .get:
            routes.get(endpoint.pathComponents) { _ in try self.jsonResponse(for: route) }
        case .post:
            routes.post(endpoint.pathComponents) { _ in try self.jsonResponse(for: route) }
        case .put:
            routes.put(endpoint.pathComponents) { _ in try self.jsonResponse(for: route) }
        case .patch:
            routes.patch(endpoint.pathComponents) { _ in try self.jsonResponse(for: route) }
        case .delete:
            routes.delete(endpoint.pathComponents) { _ in try self.jsonResponse(for: route) }
        }
    }
    
    private func jsonResponse(for route: MockRoute) throws -> String {
        let status = HTTPResponseStatus(statusCode: route.code)
        guard status.mayHaveResponseBody else { throw Abort(status) }
        return route.json
    }
}
