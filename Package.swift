// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MCKillSwitch",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9)
    ],
    products: [
        .library(name: "MCKillSwitch", targets: ["MCKillSwitch"])
    ],
    targets: [
        .target(
            name: "MCKillSwitch",
            path: "Sources/MCKillSwitch",
            publicHeadersPath: "include"
        )
    ]
)
