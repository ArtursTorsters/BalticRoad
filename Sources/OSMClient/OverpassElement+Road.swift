// Converts Overpass's raw wire format into our own Road model. Lives here
// (not in SharedModels) because SharedModels must stay dependency-free —
// this file already depends on both OverpassElement (this package) and
// Road (via SharedModels), so it's the only side that can know about both.

import SharedModels

extension OverpassElement {
    func toRoad() -> Road {
        Road(
            id: String(id),
            name: tags["name"],
            // TODO: real surface-tag mapping lands in issue #14
            surface: .unknown,
            coordinates: geometry.map { Coordinate(latitude: $0.lat, longitude: $0.lon) }
        )
    }
}
