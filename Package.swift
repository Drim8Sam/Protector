// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Protector",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Protector", targets: ["Protector"])
    ],
    targets: [
        .target(name: "Protector", path: "Sources"),
        .testTarget(name: "ProtectorTests", path: "Tests")
    ]
)
