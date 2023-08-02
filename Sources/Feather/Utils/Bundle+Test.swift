import Foundation

extension Bundle {
    static let test: Bundle? = {
        guard
            let moduleName = Bundle(for: BundleFinder.self).bundleIdentifier,
            let testBundlePath = ProcessInfo.processInfo.environment["XCTestBundlePath"],
            let bundle = Bundle(path: testBundlePath + "/" + "Feather_\(moduleName).bundle")
        else { return nil}
        return bundle
    }()
    
    private final class BundleFinder {}
}
