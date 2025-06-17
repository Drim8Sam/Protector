/// Упрощённая модель для отображения в UI
struct FileSummary: Identifiable, Hashable {
    let id = UUID()          // уникальный идентификатор для SwiftUI List
    let path: String         // относительный путь к файлу внутри проекта
}

