import Foundation
//import ProjectScanner

/// Сервис сканирования проекта на уровне файловой системы
public final class ScanService {
    private let scanner = FileScanner()

    public init() {}

    /// Возвращает список исходных файлов проекта
    public func scanProject(at url: URL) throws -> [FileInfo] {
        try scanner.scanProject(at: url)
    }
}
