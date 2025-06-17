import Foundation
import Combine
//import ProjectScanner     // FileInfo
//import CodeParser         // ParsedFile
//import RuleEngine         // Vulnerability
//import AppServices        // ParseService, RuleService, ReportService

@MainActor
public final class DetailViewModel: ObservableObject {
    @Published public private(set) var vulnerabilities: [Vulnerability] = []
    @Published public var errorMessage: String?

    private let parseService = ParseService()
    private let ruleService = RuleService()
    private let reportService = ReportService()

    /// Запустить полный анализ: от FileInfo до списка Vulnerability
    public func analyze(_ fileInfos: [FileInfo]) async {
        do {
            let parsed = try await parseService.parse(fileInfos)
            let vulns  = try await ruleService.check(parsed)
            self.vulnerabilities = vulns
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    /// Сохранить JSON-отчёт по уязвимостям
    public func saveJSON(to url: URL) {
        do {
            try reportService.saveJSON(vulnerabilities, to: url)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    /// Сохранить CSV-отчёт по уязвимостям
    public func saveCSV(to url: URL) {
        do {
            try reportService.saveCSV(vulnerabilities, to: url)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
