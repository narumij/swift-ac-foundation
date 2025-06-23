// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var defines: [String] = []

var _settings: [SwiftSetting] = defines.map { .define($0) }

let package = Package(
  name: "swift-ac-foundation",
  platforms: [.macOS(.v14), .iOS(.v17), .tvOS(.v17), .watchOS(.v10), .macCatalyst(.v17)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(name: "AcFoundation", targets: ["AcFoundation"])
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-algorithms",
      from: "1.2.1"),
    .package(
      url: "https://github.com/attaswift/BigInt",
      from: "5.6.0"),
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
      name: "Pack",
      dependencies: ["IOReader"],
      swiftSettings: _settings),
    .target(
      name: "cxx",
      cxxSettings: [
          .headerSearchPath("include"),
          .unsafeFlags(["-std=c++17"])
      ]),
    .target(
      name: "CxxWrapped",
      dependencies: ["cxx"],
      swiftSettings: _settings),
    .target(
      name: "CharacterUtil",
      dependencies: ["cxx"],
    ),
    .target(
      name: "Miscellaneous",
      dependencies: ["IOReader"],
      swiftSettings: _settings),
    .target(
      name: "Convinience",
      swiftSettings: _settings),
    .target(
      name: "AcFoundation",
      dependencies: [
        "IOReader",
        "IOUtil",
        "Bisect",
        "Pack",
        "CxxWrapped",
        "CharacterUtil",
        "Miscellaneous",
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "AcFoundationTests",
      dependencies: [
        "IOReader",
        "IOUtil",
        "Bisect",
        "Pack",
        "CxxWrapped",
        "CharacterUtil",
        .product(name: "Algorithms", package: "swift-algorithms"),
        .product(name: "BigInt", package: "BigInt"),
      ],
      resources: [
          .copy("Resources")
      ],
      swiftSettings: _settings
    ),
  ]
)
