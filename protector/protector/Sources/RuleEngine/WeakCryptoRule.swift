import Foundation

/// Finds usage of weak cryptographic algorithms like MD5 or SHA1
public final class WeakCryptoRule: VulnerabilityRule {
    public let id = "weak_crypto"

    public init() {}

    public func check(in file: ParsedFile) throws -> [Vulnerability] {
        let lines = file.syntax.description.components(separatedBy: .newlines)
        var results: [Vulnerability] = []
        for (idx, line) in lines.enumerated() {
            let lower = line.lowercased()
            if lower.contains("md5") || lower.contains("sha1") {
                results.append(
                    Vulnerability(file: file.url.path, type: id, line: idx + 1, severity: .high)
                )
            }
        }
        return results
    }
}
