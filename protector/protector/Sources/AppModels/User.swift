/// Структура для хранения пользовательских настроек (последний проект, фильтры и т.д.)
struct UserSettings: Codable {
    var lastProjectURL: URL?
    var showHighSeverityOnly: Bool = false
    // + любая другая конфигурация из SettingsView
}

