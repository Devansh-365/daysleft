// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "days-left",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "days-left", targets: ["days-left"])
    ],
    targets: [
        .executableTarget(
            name: "days-left",
            path: ".",
            exclude: ["tests", "resources", "docs", "research", ".gitignore", "README.md", "CHANGELOG.md", "RELEASE_NOTES.md", "Makefile", ".github"]
        ),
        .testTarget(
            name: "days-left-tests",
            dependencies: ["days-left"],
            path: "tests"
        )
    ]
)
