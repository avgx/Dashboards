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
    targets: [
        .target(name: "DashboardsCore"),
        .target(name: "DashboardsUI", dependencies: ["DashboardsCore"]),
        .testTarget(name: "DashboardsTests", dependencies: ["DashboardsCore"]
        ),
    ]
)
