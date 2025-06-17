import Foundation
import Combine
import AppModels           // FileSummary
import ProjectScanner      // FileScanner
import AppServices         // ScanService

@MainActor
final class MainViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var projectURL: URL?
    @Published var fileSummaries: [FileSummary] = []
    @Published var errorMessage: String?

    private let scanService = ScanService()

    // Отфильтрованный список в зависимости от поисковой строки
    var filteredFileSummaries: [FileSummary] {
        guard !searchQuery.isEmpty else { return fileSummaries }
        return fileSummaries.filter { $0.path.localizedCaseInsensitiveContains(searchQuery) }
    }

    // Открыть NSOpenPanel для выбора директории
    func chooseDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.prompt = "Выбрать"
        if panel.runModal() == .OK, let url = panel.url {
            projectURL = url
            scanDirectory(at: url)
        }
    }

    // Сканировать папку через ScanService
    private func scanDirectory(at url: URL) {
        Task {
            do {
                let infos = try scanService.scanProject(at: url)
                // Преобразовать FileInfo в FileSummary для UI
                self.fileSummaries = infos.map { FileSummary(path: $0.path) }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // Загрузка последнего сохранённого отчёта (если реализовано)
    func loadLastReport() {
        // TODO: вызвать соответствующий ReportService.loadLastReport()
    }

    // Запустить полный анализ (скан + парс + правила)
    func runAnalysis() {
        guard let url = projectURL else { return }
        scanDirectory(at: url)
        // TODO: по завершении скана вызывать ParseService и RuleService,
        // затем переходить на экран с деталями (DetailView)
    }
}

