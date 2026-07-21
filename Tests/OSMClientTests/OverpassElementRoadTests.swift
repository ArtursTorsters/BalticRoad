// Tests for converting Overpass's raw wire format into our Road model.

import Testing
@testable import OSMClient

@Test func toRoadUsesNameTagWhenPresent() {
    let element = OverpassElement(
        id: 42,
        geometry: [OverpassGeometryPoint(lat: 56.9, lon: 24.1)],
        tags: ["name": "A6", "surface": "asphalt"]
    )

    let road = element.toRoad()

    #expect(road.id == "42")
    #expect(road.name == "A6")
    #expect(road.coordinates.count == 1)
    #expect(road.coordinates[0].latitude == 56.9)
    #expect(road.coordinates[0].longitude == 24.1)
}

@Test func toRoadHasNilNameWhenTagMissing() {
    let element = OverpassElement(id: 1, geometry: [], tags: [:])

    #expect(element.toRoad().name == nil)
}
