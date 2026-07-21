// Command-line entry point that exercises the core packages together.
// Stands in for the SwiftUI app until Xcode is available; run it with
// `swift run BalticRoadAtlasCLI`.

import CamperEngine
import HistoricalRoutes
import RoadScoring
import SharedModels

@main
struct BalticRoadAtlasCLI {
    static func main() {
        let a6 = Road(
            id: "a6",
            name: "A6 Rīga–Daugavpils",
            surface: .asphalt,
            coordinates: [
                Coordinate(latitude: 56.9496, longitude: 24.1052),
                Coordinate(latitude: 55.8747, longitude: 26.5363),
            ]
        )

        let score = RoadScoreCalculator().score(for: a6)
        print("\(a6.name ?? "Unnamed road"): score \(score.value)/10 (confidence: \(score.confidence))")

        let campsite = CamperPOI(
            id: "poi-1",
            name: "Rāzna National Park overnight spot",
            coordinate: Coordinate(latitude: 56.3167, longitude: 27.5333),
            amenities: [.overnightParking, .drinkingWater, .toilet]
        )
        let matches = CamperPOIFilter().poiList([campsite], containingAll: [.overnightParking])
        print("Camper POIs with overnight parking: \(matches.map(\.name))")

        let balticWay = BalticWayRoute(waypoints: [
            HistoricalWaypoint(
                id: "wp-1",
                title: "Freedom Monument, Rīga",
                coordinate: Coordinate(latitude: 56.9515, longitude: 24.1147),
                year: 1989,
                details: "Southern endpoint of the Latvian section of the Baltic Way."
            ),
        ])
        print("Baltic Way waypoints: \(balticWay.waypoints.map(\.title))")
    }
}
