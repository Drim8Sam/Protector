import Foundation
import ProjectScanner    // FileInfo
import CodeParser        // ParsedFile, ParserEngine

/// Сервис парсинга — получает сырые FileInfo, выдаёт AST-представления
public final class ParseService {
    private let parser = ParserEngine()

    /// Разбирает код и возвращает список ParsedFile
    public func parse(_ files: [FileInfo]) async throws -> [ParsedFile] {
        return try await withThrowingTaskGroup(of: ParsedFile.self) { group in
            for file in files {
                group.addTask {
                    // сохраняем содержимое во временный файл и парсим
                    try await self.parser.parseFile(file)
                }
            }
            var parsed: [ParsedFile] = []
            for try await pf in group {
                parsed.append(pf)
            }
            return parsed
        }
    }
}
