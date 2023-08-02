import Foundation

struct Logger {
    static let shared = Logger()

    private let logPrefix = "🪶 [Feather]"
    
    func debug(_ message: String) {
        print("\(logPrefix) \(message)")
    }
    
    func error(_ message: String? = nil,
               error: Error? = nil) {
        var errorMessage = ""
        
        if let message {
            errorMessage.append("\(message) ")
        }
        
        if let error {
            errorMessage.append("\(error)")
        }
        
        print("\(logPrefix) [Error] \(errorMessage)")
    }
}
