// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Balatro",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/tomsci/LuaSwift", from: "0.3.0")
    ],
    targets: [
        .executableTarget(
           name: "balatro",
           dependencies: [
                .product(name: "Lua", package: "LuaSwift"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
           ]
        )
    ]
)
