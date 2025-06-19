/// Структура для хранения пользовательских настроек (последний проект, фильтры и т.д.)
import Foundation
public struct UserSettings: Codable {
    public var lastProjectURL: URL?
    public var showHighSeverityOnly: Bool = false
    // + любая другая конфигурация из SettingsView

    public init(lastProjectURL: URL? = nil, showHighSeverityOnly: Bool = false) {
        self.lastProjectURL = lastProjectURL
        self.showHighSeverityOnly = showHighSeverityOnly
    }
}

