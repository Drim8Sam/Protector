import Foundation
import Combine
// FileInfo, ParsedFile, Vulnerability and services are defined in the same module

@MainActor
public final class DetailViewModel: ObservableObject, RuleServiceDelegate {
    @Published public private(set) var vulnerabilities: [Vulnerability] = []
    @Published public var errorMessage: String?

    private let parseService = ParseService()
    private let ruleService = RuleService()
    private let reportService = ReportService()

    /// Запустить полный анализ: от FileInfo до списка Vulnerability
    public func analyze(_ fileInfos: [FileInfo]) async {
        do {
            ruleService.delegate = self
            parseService.onParsedFile = { _ in }
            self.vulnerabilities.removeAll()
            let parsed = try await parseService.parse(fileInfos)
            let vulns  = try await ruleService.check(parsed)
            self.vulnerabilities = vulns
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    public func ruleService(_ service: RuleService, didCheck vulnerabilities: [Vulnerability]) {
        self.vulnerabilities.append(contentsOf: vulnerabilities)
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
