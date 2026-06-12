// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var defines: [String] = []

var _settings: [SwiftSetting] =
  [
    .define("BENCHMARK", .when(traits: ["BENCHMARK"])),

    .define("DEATH_TEST", .when(platforms: [.macOS])),

  ] + defines.map { .define($0) }

//let platforms: [SupportedPlatform]? =
//  defines.contains("???")
//  ? [.macOS(.v14), .iOS(.v17), .tvOS(.v17), .watchOS(.v10), .macCatalyst(.v17)]
//  : nil

let package = Package(
  name: "swift-ac-foundation",
  //  platforms: [.macOS(.v14), .iOS(.v17), .tvOS(.v17), .watchOS(.v10), .macCatalyst(.v17)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(name: "AcFoundation", targets: ["AcFoundation"])
  ],
  traits: [],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-algorithms",
      from: "1.2.1"),
    .package(
      url: "https://github.com/attaswift/BigInt",
      from: "5.7.0"),
    .package(
      url: "https://github.com/narumij/swift-ac-library",
      branch: "develop/after2025/0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "_FastIO",
      publicHeadersPath: "include",
      cSettings: [
        .headerSearchPath("include"),
        .define("NDEBUG", .when(configuration: .release)),
      ]),
    .target(
      name: "IOReader",
      dependencies: ["_FastIO"],
      swiftSettings: _settings),
    .target(
      name: "IOReaderExtra",
      dependencies: [
        "IOReader",
        "Pack",
        .product(name: "BigInt", package: "BigInt"),
        .product(name: "AtCoder", package: "swift-ac-library"),
      ],
      swiftSettings: _settings
    ),
    .target(
      name: "IOUtil",
      dependencies: ["_FastIO"],
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
        .unsafeFlags(["-std=c++17"]),
      ]
    ),
    .target(
      name: "_MT19937",
      publicHeadersPath: "include",
      cxxSettings: [
        .headerSearchPath("include"),
        .define("NDEBUG", .when(configuration: .release)),
        .unsafeFlags(["-std=c++17"]),
      ]),
    .target(
      name: "MT19937",
      dependencies: ["_MT19937"],
      swiftSettings: _settings),
    .target(
      name: "CxxWrapped",
      dependencies: ["_cxx"],
      swiftSettings: _settings),
    .target(
      name: "CharacterUtil",
      dependencies: ["IOUtil"],
      swiftSettings: _settings),
    .target(
      name: "StringUtil",
      swiftSettings: _settings),
    .target(
      name: "UInt8Util",
      dependencies: ["IOUtil"],
      swiftSettings: _settings),
    .target(
      name: "Miscellaneous",
      dependencies: ["IOReader"],
      swiftSettings: _settings),
    .target(
      name: "Convenience",
      dependencies: [
        "Pack",
        .product(name: "BigInt", package: "BigInt"),
      ],
      swiftSettings: _settings),
    .target(
      name: "TestingUtil",
      dependencies: [
        .product(name: "Algorithms", package: "swift-algorithms")
      ],
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
        "TestingUtil",
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "BisectTests",
      dependencies: [
        "Bisect"
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "IOReaderTests",
      dependencies: [
        "TestingUtil",
        "IOReader",
        "UInt8Util",
        "Pack",
      ],
      resources: [
        .copy("Resources")
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "IOReaderExtraTests",
      dependencies: [
        "TestingUtil",
        "IOReaderExtra",
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "IOUtilTests",
      dependencies: [
        "TestingUtil",
        "IOUtil",
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "CxxWrappedTests",
      dependencies: [
        "TestingUtil",
        "CxxWrapped",
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "PackTests",
      dependencies: [
        "TestingUtil",
        "Pack",
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "StringUtilTests",
      dependencies: [
        "TestingUtil",
        "StringUtil",
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "CharacterUtilTests",
      dependencies: [
        "TestingUtil",
        "CharacterUtil",
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "UInt8UtilTests",
      dependencies: [
        "TestingUtil",
        "UInt8Util",
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "MT19937Tests",
      dependencies: [
        "TestingUtil",
        "MT19937",
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "MiscellaneousTests",
      dependencies: [
        "TestingUtil",
        "Miscellaneous",
        "Pack"
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "ConvenienceTests",
      dependencies: [
        "TestingUtil",
        "Convenience",
        .product(name: "Algorithms", package: "swift-algorithms")
      ],
      swiftSettings: _settings
    ),
    .testTarget(
      name: "TestingUtilTests",
      dependencies: [
        "TestingUtil"
      ],
      swiftSettings: _settings
    ),
  ]
)
