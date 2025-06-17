import Foundation
import Combine
import ProjectScanner
import CodeParser

public final class MainViewModel: ObservableObject {
    @Published public private(set) var files: [FileInfo] = []
    @Published public private(set) var parsedFiles: [ParsedFile] = []
    @Published public private(set) var errorMessage: String?

    private let scanner = FileScanner()
    private let parser = ParserEngine()

    /// Запускает сканирование и парсинг проекта
    public func loadProject(at url: URL) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let scanned = try self.scanner.scanProject(at: url)
                let parsed = try self.parser.parseFiles(scanned)
                DispatchQueue.main.async {
                    self.files = scanned
                    self.parsedFiles = parsed
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
