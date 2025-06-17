import Foundation
import SwiftSyntax
import SwiftParser
import ProjectScanner

/// Обёртка над SwiftSyntax для разбора исходников
public final class ParserEngine {
    public init() {}

    /// Разбор одного файла
    public func parseFile(_ file: FileInfo) async throws -> ParsedFile {
        let syntax = Parser.parse(source: file.content)
        return ParsedFile(url: URL(fileURLWithPath: file.path), syntax: syntax)
    }

    /// Опциональный метод для разбора списка файлов
    public func parseFiles(_ files: [FileInfo]) async throws -> [ParsedFile] {
        try await withThrowingTaskGroup(of: ParsedFile.self) { group in
            for f in files { group.addTask { try await self.parseFile(f) } }
            var results: [ParsedFile] = []
            for try await pf in group { results.append(pf) }
            return results
        }
    }
}
