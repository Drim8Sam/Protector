import Foundation
import CodeParser

public final class RuleEngine {
    private let rules: [VulnerabilityRule] = [
        ForceUnwrapRule(),
        HardcodedSecretRule(),
        // … другие правила
    ]

    public func run(on file: ParsedFile) throws -> [Vulnerability] {
        try rules.flatMap { try $0.check(in: file) }
    }
}
