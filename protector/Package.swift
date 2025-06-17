// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "protector",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "protector", targets: ["App"]),
    ],
    dependencies: [
        // 1) SwiftSyntax — для разбора .swift-файлов в AST
        .package(url: "https://github.com/apple/swift-syntax.git", from: "0.50600.1"),
        // 2) CodableCSV — удобная сериализация CSV (опционально)
        .package(url: "https://github.com/dehesa/CodableCSV.git", from: "0.6.4"),
        // 3) swift-log — для гибкого логирования (опционально)
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0"),
    ],
    targets: [
        .target(
            name: "ProjectScanner",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax")
            ],
            path: "protector/Sources/ProjectScanner"
        ),
        .target(
            name: "CodeParser",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax")
            ],
            path: "protector/Sources/CodeParser"
        ),
        .target(
            name: "RuleEngine",
            dependencies: [],
            path: "protector/Sources/RuleEngine"
        ),
        .target(
            name: "ResultAggregator",
            dependencies: [
                .product(name: "CodableCSV", package: "CodableCSV")
            ],
            path: "protector/Sources/ResultAggregator"
        ),
        .target(
            name: "AppModels",
            dependencies: [],
            path: "protector/Sources/AppModels"
        ),
        .target(
            name: "AppServices",
            dependencies: [
                "ProjectScanner",
                "CodeParser",
                "RuleEngine",
                .product(name: "CodableCSV", package: "CodableCSV")
            ],
            path: "protector/Sources/AppServices"
        ),
        .target(
            name: "AppViewModels",
            dependencies: [
                "AppModels",
                "AppServices",
                "ProjectScanner",
                "CodeParser",
                "RuleEngine",
                .product(name: "CodableCSV", package: "CodableCSV")
            ],
            path: "protector/Sources/AppViewModels"
        ),
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
        )
    ]
)
