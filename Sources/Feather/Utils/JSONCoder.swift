import Foundation

class JSONCoder: Codable {
    
    static func decode(from filename: String) -> String {
        let bundle: Bundle = Bundle.test ?? Bundle(for: Self.self)
        let path = bundle.path(forResource: filename, ofType: "json")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url, options: .mappedIfSafe)
        let string = String(decoding: data, as: UTF8.self)
        return string
    }
    
    static func encode(_ object: Encodable) -> String {
        guard let data = try? JSONEncoder().encode(object) else { return "" }
        return String(data: data,encoding: .utf8) ?? ""
    }
}
