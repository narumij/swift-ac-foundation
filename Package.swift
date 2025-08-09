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
      from: "5.7.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "IOReader",
      swiftSettings: _settings),
    .target(
      name: "_FastPrint",
      publicHeadersPath: "include",
      cSettings: [
        .headerSearchPath("include"),
        .define("NDEBUG", .when(configuration: .release)),
      ]),
    .target(
      name: "IOUtil",
      dependencies: ["_FastPrint"],
      swiftSettings: _settings),
    .target(
      name: "Bisect",
      swiftSettings: _settings),
    .target(
      name: "Pack",
      dependencies: ["IOReader"],
      swiftSettings: _settings),
    .target(
      name: "_cxx",
      publicHeadersPath: "include",
      cxxSettings: [
          .headerSearchPath("include"),
          .define("NDEBUG", .when(configuration: .release)),
          .unsafeFlags(["-std=c++17"])
      ]
    ),
    .target(
      name: "_MT19937",
      publicHeadersPath: "include",
      cxxSettings: [
        .headerSearchPath("include"),
        .define("NDEBUG", .when(configuration: .release)),
//        .unsafeFlags(["-std=c++17"])
      ],
      swiftSettings: [
//        .interoperabilityMode(.Cxx)
      ]),
    .target(
      name: "MT19937",
      dependencies: ["_MT19937"],
//      swiftSettings: [
//        .interoperabilityMode(.Cxx)
//      ]
    ),
    .target(
      name: "CxxWrapped",
      dependencies: ["_cxx"],
      swiftSettings: _settings),
    .target(
      name: "CharacterUtil",
    ),
    .target(
      name: "StringUtil",
    ),
    .target(
      name: "UInt8Util",
    ),
    .target(
      name: "Miscellaneous",
      dependencies: ["IOReader"],
      swiftSettings: _settings),
    .target(
      name: "Convenience",
      dependencies: ["Pack"],
      swiftSettings: _settings),
    .target(
      name: "AcFoundation",
      dependencies: [
        "IOReader",
        "Bisect",
        "Pack",
        "IOUtil",
        "CxxWrapped",
        "StringUtil",
        "CharacterUtil",
        "UInt8Util",
        "Miscellaneous",
        "Convenience",
        "MT19937",
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
        "StringUtil",
        "CharacterUtil",
        "UInt8Util",
        "Miscellaneous",
        "Convenience",
        "MT19937",
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
