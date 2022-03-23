// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSClientExposure",
    platforms: [.iOS(.v9),
                .tvOS(.v9)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "iOSClientExposure",
            targets: ["iOSClientExposure", "iOSClientExposureObjc"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "4.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "iOSClientExposure",
            dependencies: [], exclude: ["Info.plist"]),
        .target(
            name: "iOSClientExposureObjc",
            dependencies: []),
        .testTarget(
            name: "iOSClientExposureTests",
            dependencies: ["iOSClientExposure","Quick", "Nimble"], exclude: ["Info.plist"]),
    ]
)
