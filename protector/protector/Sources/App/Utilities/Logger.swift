import Logging

/// Глобальный логгер
extension Logger {
    static var app: Logger = {
        var log = Logger(label: "com.protector.app")
        log.logLevel = .info
        return log
    }()
}

