import Foundation
/// Упрощённая модель для отображения в UI
public struct FileSummary: Identifiable, Hashable {
    public let id = UUID()          // уникальный идентификатор для SwiftUI List
    public let path: String         // относительный путь к файлу внутри проекта

    public init(path: String) {
        self.path = path
    }
}

