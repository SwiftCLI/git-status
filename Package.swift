// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "git-status",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "git-status", targets: ["git-status"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0")),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "0.4.0")),
        .package(url: "https://github.com/OpenCombine/OpenCombine.git", .upToNextMajor(from: "0.12.0")),
        .package(url: "https://github.com/scottrhoyt/SwiftyTextTable.git", .upToNextMajor(from: "0.5.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "git-status",
            dependencies: ["OpenCombineShim",
                           "SwiftyTextTable",
                           "Alamofire",
                           .product(name: "ArgumentParser", package: "swift-argument-parser"),
                           .product(name: "OpenCombineFoundation", package: "OpenCombine"),
                           .product(name: "OpenCombineDispatch", package: "OpenCombine")]),
        .testTarget(
            name: "git-statusTests",
            dependencies: ["git-status"]),
    ]
)
