// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "CodeAudit",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(name: "CodeAudit", targets: ["AppUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "0.50600.1"),
    ],
    targets: [
        .target(
            name: "ProjectScanner",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax")
            ],
            path: "Sources/ProjectScanner"
        ),
        .target(
            name: "CodeParser",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax")
            ],
            path: "Sources/CodeParser"
        ),
        .target(
            name: "AppUI",
            dependencies: ["ProjectScanner", "CodeParser"],
            path: "Sources/AppUI"
        ),
    ]
)
