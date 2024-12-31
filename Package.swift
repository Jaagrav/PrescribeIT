// swift-tools-version: 6.0

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "PrescribeIT",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "PrescribeIT",
            targets: ["AppModule"],
            bundleIdentifier: "com.jaagrav.PrescribeIT",
            teamIdentifier: "89659343H8",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .clock),
            accentColor: .presetColor(.indigo),
            supportedDeviceFamilies: [
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait
            ],
            capabilities: [
                .localNetwork(purposeString: "Allow to connect patient's and doctor's devices", bonjourServiceTypes: ["_prescribeit._tcp", "_prescribeit._udp"])
            ],
            appCategory: .medical
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Cindori/FluidGradient?tab=readme-ov-file", "1.0.0"..<"2.0.0"),
        .package(url: "https://github.com/nazar-41/pdf-generator", .branch("main"))
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "FluidGradient", package: "fluidgradient?tab=readme-ov-file"),
                .product(name: "PDF-Generator", package: "pdf-generator")
            ],
            path: ".",
            resources: [
                .process("Resources")
            ]
        )
    ],
    swiftLanguageVersions: [.version("6")]
)
