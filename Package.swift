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
            exclude: ["tests", "resources", "docs", "research", ".gitignore", "README.md"]
        ),
        .testTarget(
            name: "days-left-tests",
            dependencies: ["days-left"],
            path: "tests"
        )
    ]
)
