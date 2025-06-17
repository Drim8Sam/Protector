/// Структура для хранения пользовательских настроек (последний проект, фильтры и т.д.)
import Foundation
struct UserSettings: Codable {
    var lastProjectURL: URL?
    var showHighSeverityOnly: Bool = false
    // + любая другая конфигурация из SettingsView
}

