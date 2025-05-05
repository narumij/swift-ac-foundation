// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var defines: [String] = [
  //  "TEST_FATAL_ERROR"
]

var _settings: [SwiftSetting] = defines.map { .define($0) }

let package = Package(
  name: "AcFoundation",
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(name: "AcFoundation", targets: ["AcFoundation"])
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-algorithms",
      exact: "1.2.1")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "IOReader",
      swiftSettings: _settings),
    .target(
      name: "IOUtil",
      swiftSettings: _settings),
    .target(
      name: "Bisect",
      swiftSettings: _settings),
    .target(
      name: "AcFoundation",
      dependencies: [
        "IOReader",
        "IOUtil",
        "Bisect",
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "AcFoundationTests",
      dependencies: [
        "AcFoundation",
        .product(name: "Algorithms", package: "swift-algorithms"),
      ],
      resources: [
          .copy("Resources")
      ],
      swiftSettings: _settings
    ),
  ]
)
