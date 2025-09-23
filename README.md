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

## Test
Create .env file with
```
API=https://cloud.url.com/
TOKEN=eyJhbGciO...mnH8ag
```

One liner run:
```
(source .env && xcodebuild test -scheme "Dashboards-Package" -destination 'platform=iOS Simulator,name=iPhone 16e,OS=26.0')
```
Or add environment variables via XCode "Edit scheme..." menu item. 