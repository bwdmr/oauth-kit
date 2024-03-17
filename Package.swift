// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Imperial",
    products: [
      // Products define the executables and libraries a package produces, making them visible to other packages.
      .library(name: "ImperialCore", targets: ["ImperialCore"]),
      .library(name: "ImperialGoogle", targets: ["ImperialCore", "ImperialGoogle"]),
      .library(name: "Imperial", targets: [
        "ImperialCore"
      ]),
    ],
    dependencies: [
      .package(url: "https://github.com/vapor/vapor.git", from: "4.92.4"),
    ],
    targets: [
      // Targets are the basic building blocks of a package, defining a module or a test suite.
      // Targets can depend on other targets in this package and products from dependencies.
      .target(
        name: "ImperialCore",
        dependencies: [
          .product(name: "Vapor", package: "vapor")
        ]
      ),
      .target(name: "ImperialGoogle", dependencies: ["ImperialCore"]),
      .testTarget( name: "ImperialTests", dependencies: ["ImperialCore"]),
    ]
)
