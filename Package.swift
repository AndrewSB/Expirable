// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "Expirable",
  platforms: [.iOS(.v13)],
  products: [.library(name: "Expirable", targets: ["Expirable"])],
  dependencies: [],
  targets: [
    .target(
      name: "Expirable",
      path: "Source",
      exclude: ["README.md", "Example.playground", "Cartfile.resolved"]
    )
  ]
)
