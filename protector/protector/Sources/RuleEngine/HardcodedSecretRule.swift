import SwiftSyntax

public final class HardcodedSecretRule: VulnerabilityRule {
    public let id = "hardcoded_secret"
    public func check(in file: ParsedFile) throws -> [Vulnerability] { /*…*/ }
}
