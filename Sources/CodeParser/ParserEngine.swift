import Foundation
import SwiftSyntax

public struct ParsedFile {
    public let url: URL
    public let syntax: SourceFileSyntax
}

public final class ParserEngine {
    /// Разбирает каждый FileInfo в AST с помощью SwiftSyntax
    public func parseFiles(_ files: [FileInfo]) throws -> [ParsedFile] {
        var parsed: [ParsedFile] = []
        for file in files {
            let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent(UUID().uuidString + ".swift")
            try file.content.write(to: tempURL, atomically: true, encoding: .utf8)

            let sourceFile = try SyntaxParser.parse(tempURL)
            parsed.append(ParsedFile(url: tempURL, syntax: sourceFile))
        }
        return parsed
    }
}
