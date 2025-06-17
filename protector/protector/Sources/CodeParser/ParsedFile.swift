import Foundation
import SwiftSyntax
import SwiftSyntaxParser

/// Результат разбора исходного файла
public struct ParsedFile: Identifiable {
    public let id = UUID()
    /// URL исходного файла
    public let url: URL
    /// AST представление содержимого
    public let syntax: SourceFileSyntax

    public init(url: URL, syntax: SourceFileSyntax) {
        self.url = url
        self.syntax = syntax
    }
}
