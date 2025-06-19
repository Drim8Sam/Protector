import Foundation

/// Rule that detects storing data in UserDefaults without encryption
public final class InsecureDataStorageRule: VulnerabilityRule {
    public let id = "insecure_data_storage"

    public init() {}

    public func check(in file: ParsedFile) throws -> [Vulnerability] {
        let lines = file.syntax.description.components(separatedBy: .newlines)
        var results: [Vulnerability] = []
        for (idx, line) in lines.enumerated() {
            if line.contains("UserDefaults.standard.set") {
                results.append(
                    Vulnerability(file: file.url.path, type: id, line: idx + 1, severity: .medium)
                )
            }
        }
        return results
    }
}
