# Dashboards
Dashboards provides SwiftUI Views to view data.

## Requirements

- Swift 5.10+ (Xcode 15+)
- iOS 15+, iPadOS 15+

## Installation

Install using Swift Package Manager

```
dependencies: [
    .package(url: "https://github.com/avgx/Dashboards.git", branch: "main"),
],
targets: [
    .target(name: "MyTarget", dependencies: [
        .product(name: "DashboardsCore", package: "Dashboards"),
        .product(name: "DashboardsUI", package: "Dashboards"),
    ]),
]
```

And import it:
```swift
import DashboardsCore
import DashboardsUI
```

## Usage
