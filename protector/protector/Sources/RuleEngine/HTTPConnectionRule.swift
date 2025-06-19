import Foundation

/// Detects usage of insecure HTTP protocol
public final class HTTPConnectionRule: VulnerabilityRule {
    public let id = "http_connection"

    public init() {}

    public func check(in file: ParsedFile) throws -> [Vulnerability] {
        let lines = file.syntax.description.components(separatedBy: .newlines)
        var results: [Vulnerability] = []
        for (idx, line) in lines.enumerated() {
            if line.lowercased().contains("http://") {
                results.append(
                    Vulnerability(file: file.url.path, type: id, line: idx + 1, severity: .medium)
                )
            }
        }
        return results
    }
}
