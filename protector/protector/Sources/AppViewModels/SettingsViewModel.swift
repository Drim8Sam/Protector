import Foundation
import AppModels

/// ViewModel для экрана настроек
@MainActor
public final class SettingsViewModel: ObservableObject {
    @Published public var settings = UserSettings()

    private let key = "user_settings"

    public init() {
        load()
    }

    /// Загрузка настроек из UserDefaults
    public func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let saved = try? JSONDecoder().decode(UserSettings.self, from: data)
        else { return }
        settings = saved
    }

    /// Сохранение текущих настроек
    public func save() {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
