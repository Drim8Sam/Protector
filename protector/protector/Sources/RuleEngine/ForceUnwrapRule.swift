import Foundation

/// Правило детекции оператора force unwrap (!)
public final class ForceUnwrapRule: VulnerabilityRule {
    public let id = "force_unwrap"

    public init() {}

    public func check(in file: ParsedFile) throws -> [Vulnerability] {
        let lines = file.syntax.description.components(separatedBy: .newlines)
        var result: [Vulnerability] = []
        for (idx, line) in lines.enumerated() {
            if line.contains("!") {
                result.append(Vulnerability(file: file.url.path, type: id, line: idx + 1, severity: .medium))
            }
        }
        return result
    }
}
