import Foundation
import CodeParser        // ParsedFile
import RuleEngine        // VulnerabilityRule, RuleEngine

/// Сервис проверки AST-дерева на уязвимости
public final class RuleService {
    private let engine = RuleEngine()

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
            }
            return allVulns
        }
    }
}
