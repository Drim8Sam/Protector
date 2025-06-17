import Foundation

/// Класс рекурсивного обхода проекта и сбора исходников
public final class FileScanner {
    public init() {}

    /// Сканирует проект по переданному пути и возвращает список найденных .swift файлов
    /// - Parameter url: корневая директория проекта
    /// - Returns: массив `FileInfo` с относительными путями и содержимым файлов
    public func scanProject(at url: URL) throws -> [FileInfo] {
        let fm = FileManager.default
        guard let enumerator = fm.enumerator(at: url,
                                             includingPropertiesForKeys: [.isDirectoryKey],
                                             options: [.skipsPackageDescendants, .skipsHiddenFiles])
        else { return [] }

        var result: [FileInfo] = []

        for case let fileURL as URL in enumerator {
            let values = try fileURL.resourceValues(forKeys: [.isDirectoryKey])
            if values.isDirectory == true {
                // игнорируем скрытые каталоги
                if fileURL.lastPathComponent.hasPrefix(".") {
                    enumerator.skipDescendants()
                }
                continue
            }

            // интересуют только swift-файлы
            if fileURL.pathExtension.lowercased() == "swift" {
                let content = try String(contentsOf: fileURL)
                let relative = fileURL.path.replacingOccurrences(of: url.path + "/", with: "")
                result.append(FileInfo(path: relative, content: content))
            }
        }

        return result
    }
}
