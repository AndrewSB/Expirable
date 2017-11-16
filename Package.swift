// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Expirable",
    products: [.library(name: "Expirable", targets: ["Expirable"])],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .target(
            name: "Expirable",
            dependencies: ["RxSwift"],
            exclude: ["README.md", "Example.playground", "Carthage", "Cartfile", "Cartfile.resolved"]
        )
    ],
    swiftLanguageVersions: [3, 4]
)
