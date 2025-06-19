import Foundation
// Uses Vulnerability model from the same module

/// Логика агрегации массива уязвимостей в отчёт
public struct ReportAggregator {
    public init() {}

    /// Собирает статистику и формирует `VulnerabilityReport`
    public func aggregate(_ vulns: [Vulnerability]) -> VulnerabilityReport {
        var stats: [SeverityLevel: Int] = [:]
        for v in vulns { stats[v.severity, default: 0] += 1 }
        return VulnerabilityReport(vulnerabilities: vulns, bySeverity: stats)
    }
}
