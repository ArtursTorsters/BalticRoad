// A single point of historical interest, and the 1989 Baltic Way route
// made up of them.

import SharedModels

public struct HistoricalWaypoint: Identifiable, Codable, Sendable {
    public let id: String
    public let title: String
    public let coordinate: Coordinate
    public let year: Int?
    public let details: String

    public init(id: String, title: String, coordinate: Coordinate, year: Int? = nil, details: String) {
        self.id = id
        self.title = title
        self.coordinate = coordinate
        self.year = year
        self.details = details
    }
}

/// The 1989 Baltic Way human chain route, exposed as a series of
/// waypoints that can be rendered on a map with historical context.
public struct BalticWayRoute: Sendable {
    public let waypoints: [HistoricalWaypoint]

    public init(waypoints: [HistoricalWaypoint] = []) {
        self.waypoints = waypoints
    }
}
