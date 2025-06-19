import Foundation
// Uses ParsedFile type from the same module

public final class RuleEngine {
    private let rules: [VulnerabilityRule] = [
        ForceUnwrapRule(),
        InsecureDataStorageRule(),
        HTTPConnectionRule(),
        WeakCryptoRule(),
        HardcodedSecretRule(),
        InputValidationRule()
    ]

    public func run(on file: ParsedFile) throws -> [Vulnerability] {
        try rules.flatMap { try $0.check(in: file) }
    }
}
