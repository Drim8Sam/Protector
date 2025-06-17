import Foundation
import Combine
import AppKit
import UniformTypeIdentifiers
import AppModels           // FileSummary
import ProjectScanner      // FileScanner, FileInfo
import AppServices         // ScanService
import CodableCSV

@MainActor
final class MainViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var projectURL: URL?
    @Published var fileSummaries: [FileSummary] = []
    @Published var errorMessage: String?
    @Published var shouldShowDetail: Bool = false
    @Published var lastFileInfos: [FileInfo] = []

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
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType.json, UTType.commaSeparatedText]
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let url = panel.url {
            do {
                let data = try Data(contentsOf: url)
                if url.pathExtension.lowercased() == "json" {
                    _ = try JSONDecoder().decode([Vulnerability].self, from: data)
                } else {
                    var reader = try CSVReader(string: String(decoding: data, as: UTF8.self), hasHeaderRow: true)
                    var vulns: [Vulnerability] = []
                    while let row = reader.next() {
                        if row.count >= 3, let line = Int(row[2]) {
                            vulns.append(Vulnerability(file: row[0], type: row[1], line: line))
                        }
                    }
                    _ = vulns
                }
                self.shouldShowDetail = true
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // Запустить полный анализ (скан + парс + правила)
    func runAnalysis() {
        guard let url = projectURL else { return }
        Task {
            do {
                let infos = try scanService.scanProject(at: url)
                self.lastFileInfos = infos
                self.fileSummaries = infos.map { FileSummary(path: $0.path) }
                self.shouldShowDetail = true
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

