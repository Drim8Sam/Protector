import Foundation

/// Attempts to detect use of unvalidated user input in dangerous contexts
public final class InputValidationRule: VulnerabilityRule {
    public let id = "input_validation"

    public init() {}

    public func check(in file: ParsedFile) throws -> [Vulnerability] {
        let lines = file.syntax.description.components(separatedBy: .newlines)
        var results: [Vulnerability] = []
        for (idx, line) in lines.enumerated() {
            let lower = line.lowercased()
            if (lower.contains("readline()") || lower.contains("textfield.text")) &&
                (lower.contains("url(") || lower.contains("open(") || lower.contains("eval(")) {
                results.append(
                    Vulnerability(file: file.url.path, type: id, line: idx + 1, severity: .high)
                )
            }
        }
        return results
    }
}
