
import Foundation

/// Например, удобный метод для чтения Data из URL
extension URL {
    func data() throws -> Data {
        try Data(contentsOf: self)
    }
}
