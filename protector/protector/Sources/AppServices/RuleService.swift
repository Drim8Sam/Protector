import Foundation
// ParsedFile, VulnerabilityRule and RuleEngine are defined in the same module

/// Сервис проверки AST-дерева на уязвимости
public protocol RuleServiceDelegate: AnyObject {
    func ruleService(_ service: RuleService, didCheck vulnerabilities: [Vulnerability])
}

public final class RuleService {
    private let engine = RuleEngine()
    public weak var delegate: RuleServiceDelegate?

    /// Применяет все правила и возвращает список Vulnerability
    public func check(_ parsedFiles: [ParsedFile]) async throws -> [Vulnerability] {
        return try await withThrowingTaskGroup(of: [Vulnerability].self) { group in
            for pf in parsedFiles {
                group.addTask {
                    try self.engine.run(on: pf)
                }
            }
            var allVulns: [Vulnerability] = []
            for try await list in group {
                allVulns.append(contentsOf: list)
                self.delegate?.ruleService(self, didCheck: list)
            }
            return allVulns
        }
    }
}
