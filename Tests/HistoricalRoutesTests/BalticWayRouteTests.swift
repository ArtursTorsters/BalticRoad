// Tests for the Baltic Way route model.

import Testing
import SharedModels
@testable import HistoricalRoutes

@Test func routeDefaultsToEmptyWaypoints() {
    let route = BalticWayRoute()
    #expect(route.waypoints.isEmpty)
}

@Test func routeRetainsProvidedWaypoints() {
    let waypoint = HistoricalWaypoint(
        id: "1",
        title: "Test",
        coordinate: Coordinate(latitude: 0, longitude: 0),
        details: "Details"
    )
    let route = BalticWayRoute(waypoints: [waypoint])
    #expect(route.waypoints.count == 1)
}
