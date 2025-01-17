// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let Ounchecked: [SwiftSetting] = [
  // -Ounchecked フラグを追加
  .unsafeFlags(["-Ounchecked"], .when(configuration: .release))
]

let package = Package(
  name: "AcFoundation",
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(name: "AcFoundation", targets: ["AcFoundation"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-algorithms", from: "1.1.0")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "IOReader",
      swiftSettings: Ounchecked),
    .target(
      name: "IOUtil",
      swiftSettings: Ounchecked),
    .target(
      name: "Bisect",
      swiftSettings: Ounchecked),
    .target(
      name: "AcFoundation",
      dependencies: [
        "IOReader",
        "IOUtil",
        "Bisect",
      ]),
    .testTarget(
      name: "AcFoundationTests",
      dependencies: [
        "AcFoundation",
        .product(name: "Algorithms", package: "swift-algorithms"),
      ]),
  ]
)
