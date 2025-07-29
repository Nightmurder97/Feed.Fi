// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RSCore",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "RSCore",
            targets: ["RSCore"]),
        .library(
            name: "RSCoreObjC",
            targets: ["RSCoreObjC"]),
        .library(
            name: "RSCoreResources",
            targets: ["RSCoreResources"]),
    ],
    dependencies: [
        // Dependencies go here
    ],
    targets: [
        .target(
            name: "RSCore",
            dependencies: ["RSCoreObjC", "RSCoreResources"]),
        .target(
            name: "RSCoreObjC",
            dependencies: []),
        .target(
            name: "RSCoreResources",
            dependencies: [],
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "RSCoreTests",
            dependencies: ["RSCore"]),
    ]
)
