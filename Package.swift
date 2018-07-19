import PackageDescription

let package = Package(
    name: "MarkovModel",
    products: [
        .library(
            name: "MarkovModel",
            targets: ["MarkovModel"]
        ),
    ],
    targets: [
        .target(
            name: "MarkovModel",
            dependencies: []
        ),
        .testTarget(
            name: "MarkovModelTests",
            dependencies: ["MarkovModel"]
        ),
    ]
)
