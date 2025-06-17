import Foundation
import CodableCSV         // пакет CodableCSV
//import RuleEngine         // Vulnerability

/// Сервис сохранения отчёта в JSON и CSV
public final class ReportService {
    private let encoder = JSONEncoder()

    /// Сохраняет массив уязвимостей в JSON файл
    public func saveJSON(_ vulns: [Vulnerability], to url: URL) throws {
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(vulns)
        try data.write(to: url)
    }

    /// Сохраняет массив уязвимостей в CSV файл
    public func saveCSV(_ vulns: [Vulnerability], to url: URL) throws {
        var writer = CSVWriter(stream: OutputStream(url: url, append: false)!)
        try writer.write(row: ["file", "type", "line"])
        for v in vulns {
            try writer.write(row: [v.file, v.type, String(v.line)])
        }
        writer.stream.close()
    }
}
