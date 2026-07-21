// Tests for the Overpass QL query builder.

import Testing
import SharedModels
@testable import OSMClient

@Test func roadsInBoundingBoxEmbedsCoordinatesInOrder() {
    let box = BoundingBox(
        minLatitude: 56.9,
        minLongitude: 24.0,
        maxLatitude: 57.0,
        maxLongitude: 24.2
    )

    let query = RoadQuery.roadsInBoundingBox(box)

    #expect(query.contains(#"way["highway"](56.9,24.0,57.0,24.2);"#))
}
