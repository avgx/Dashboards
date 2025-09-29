// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dashboards",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "DashboardsCore", targets: ["DashboardsCore"]),
        .library(name: "DashboardsUI", targets: ["DashboardsUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/avgx/Get", branch: "main")
    ],
    targets: [
        .target(
            name: "DashboardsCore",
            dependencies: [
                .product(name: "Get", package: "Get")
            ]
        ),
        .target(name: "DashboardsUI", dependencies: ["DashboardsCore"]),
        .testTarget(name: "DashboardsCoreTests", dependencies: ["DashboardsCore"], resources: [.process("Resources")]
        ),
    ]
)
