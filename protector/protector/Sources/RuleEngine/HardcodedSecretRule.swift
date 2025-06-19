
import Foundation
// Uses ParsedFile type from the same module
/// Поиск строковых литералов, похожих на пароли или токены
public final class HardcodedSecretRule: VulnerabilityRule {
    public let id = "hardcoded_secret"
    private let regex = try! NSRegularExpression(pattern: "(?i)(password|token|secret)\s*=\s*\"[^\"]*\"")

    public init() {}

    public func check(in file: ParsedFile) throws -> [Vulnerability] {
        let lines = file.syntax.description.components(separatedBy: .newlines)
        var results: [Vulnerability] = []
        for (idx, line) in lines.enumerated() {
            let range = NSRange(location: 0, length: line.utf16.count)
            if regex.firstMatch(in: line, range: range) != nil {
                results.append(Vulnerability(file: file.url.path, type: id, line: idx + 1, severity: .high))
            }
        }
        return results
    }
}
