import Foundation
// FileInfo, ParsedFile and ParserEngine are defined in the same module

/// Сервис парсинга — получает сырые FileInfo, выдаёт AST-представления
public final class ParseService {
    private let parser = ParserEngine()
    /// Closure called when a file is parsed
    public var onParsedFile: ((ParsedFile) -> Void)?

    /// Разбирает код и возвращает список ParsedFile
    public func parse(_ files: [FileInfo]) async throws -> [ParsedFile] {
        return try await withThrowingTaskGroup(of: ParsedFile.self) { group in
            for file in files {
                group.addTask {
                    let result = try await self.parser.parseFile(file)
                    return result
                }
            }
            var parsed: [ParsedFile] = []
            for try await pf in group {
                parsed.append(pf)
                self.onParsedFile?(pf)
            }
            return parsed
        }
    }
}
