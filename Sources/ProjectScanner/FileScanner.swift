import Foundation

public struct FileInfo {
    public let path: String
    public let content: String
}

public final class FileScanner {
    /// Рекурсивно обходит каталог и возвращает контент всех .swift-файлов
    public func scanProject(at rootURL: URL) throws -> [FileInfo] {
        var results: [FileInfo] = []
        let fm = FileManager.default
        let resourceKeys: [URLResourceKey] = [.isDirectoryKey, .isHiddenKey]
        let enumerator = fm.enumerator(at: rootURL, includingPropertiesForKeys: resourceKeys, options: [.skipsPackageDescendants])!

        for case let fileURL as URL in enumerator {
            let values = try fileURL.resourceValues(forKeys: Set(resourceKeys))
            if values.isHidden == true { enumerator.skipDescendants(); continue }
            if values.isDirectory == true { continue }
            guard fileURL.pathExtension == "swift" else { continue }

            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let relativePath = fileURL.path.replacingOccurrences(of: rootURL.path + "/", with: "")
            results.append(FileInfo(path: relativePath, content: content))
        }
        return results
    }
}
