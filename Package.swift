// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "BalticRoadAtlas",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "SharedModels", targets: ["SharedModels"]),
        .library(name: "OSMClient", targets: ["OSMClient"]),
        .library(name: "RoadScoring", targets: ["RoadScoring"]),
        .library(name: "CamperEngine", targets: ["CamperEngine"]),
        .library(name: "HistoricalRoutes", targets: ["HistoricalRoutes"]),
        .executable(name: "BalticRoadAtlasCLI", targets: ["BalticRoadAtlasCLI"]),
    ],
    targets: [
        // MARK: - Core

        .target(name: "SharedModels"),
        .testTarget(name: "SharedModelsTests", dependencies: ["SharedModels"]),

        // MARK: - Data

        .target(name: "OSMClient", dependencies: ["SharedModels"]),
        .testTarget(name: "OSMClientTests", dependencies: ["OSMClient"]),

        // MARK: - Domain engines

        .target(name: "RoadScoring", dependencies: ["SharedModels"]),
        .testTarget(name: "RoadScoringTests", dependencies: ["RoadScoring"]),

        .target(name: "CamperEngine", dependencies: ["SharedModels"]),
        .testTarget(name: "CamperEngineTests", dependencies: ["CamperEngine"]),

        .target(name: "HistoricalRoutes", dependencies: ["SharedModels"]),
        .testTarget(name: "HistoricalRoutesTests", dependencies: ["HistoricalRoutes"]),

        // MARK: - CLI (temporary UI substitute until Xcode is available)

        .executableTarget(
            name: "BalticRoadAtlasCLI",
            dependencies: [
                "SharedModels",
                "OSMClient",
                "RoadScoring",
                "CamperEngine",
                "HistoricalRoutes",
            ]
        ),
    ]
)
