import Foundation

/// ViewModel для экрана настроек
@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var settings = UserSettings()

    private let key = "user_settings"

    init() {
        load()
    }

    /// Загрузка настроек из UserDefaults
    func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let saved = try? JSONDecoder().decode(UserSettings.self, from: data)
        else { return }
        settings = saved
    }

    /// Сохранение текущих настроек
    func save() {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
