// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "protector",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        // Исполняемый продукт из таргета App
        .executable(
            name: "protector",
            targets: ["App"]
        ),
    ],
    dependencies: [
        // 1) SwiftSyntax для парсинга .swift в AST
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            from: "0.50600.1"
        ),
        // 2) CodableCSV для экспорта CSV
        .package(
            url: "https://github.com/dehesa/CodableCSV.git",
            from: "0.6.4"
        ),
        // 3) swift-log для логирования
        .package(
            url: "https://github.com/apple/swift-log.git",
            from: "1.4.0"
        ),
    ],
    targets: [
        // Модуль сканирования
        .target(
            name: "ProjectScanner",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax")
            ],
            path: "protector/Sources/ProjectScanner"
        ),

        // Модуль парсинга
        .target(
            name: "CodeParser",
            dependencies: [
                .product(name: "SwiftSyntax",       package: "swift-syntax"),
                .product(name: "SwiftSyntaxParser", package: "swift-syntax")
            ],
            path: "protector/Sources/CodeParser"
        ),

        // Модуль правил
        .target(
            name: "RuleEngine",
            dependencies: [
                "AppModels"
            ],
            path: "protector/Sources/RuleEngine"
        ),

        // Модуль агрегации отчёта
        .target(
            name: "ResultAggregator",
            dependencies: [
                .product(name: "CodableCSV", package: "CodableCSV")
            ],
            path: "protector/Sources/ResultAggregator"
        ),

        // Модели для UI
        .target(
            name: "AppModels",
            dependencies: [],
            path: "protector/Sources/AppModels"
        ),

        // Сервисы для UI
        .target(
            name: "AppServices",
            dependencies: [
                "ProjectScanner",
                "CodeParser",
                "RuleEngine",
                "ResultAggregator",
                .product(name: "CodableCSV", package: "CodableCSV")
            ],
            path: "protector/Sources/AppServices"
        ),

        // ViewModels для UI
        .target(
            name: "AppViewModels",
            dependencies: [
                "AppModels",
                "AppServices",
                "ProjectScanner",
                "CodeParser",
                "RuleEngine",
                "ResultAggregator",
                .product(name: "CodableCSV", package: "CodableCSV")
            ],
            path: "protector/Sources/AppViewModels"
        ),

        // Таргет App (SwiftUI) — точка входа
        .executableTarget(
            name: "App",
            dependencies: [
                "AppModels",
                "AppServices",
                "AppViewModels",
                "ProjectScanner",
                "CodeParser",
                "RuleEngine",
                "ResultAggregator",
                .product(name: "Logging", package: "swift-log")
            ],
            path: "protector/Sources/App"
        ),
    ]
)
