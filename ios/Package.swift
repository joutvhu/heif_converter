// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "heif_converter",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "heif_converter", targets: ["heif_converter"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "heif_converter",
            dependencies: [],
            path: "Sources/heif_converter"
        ),
    ]
)
