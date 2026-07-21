// A rectangular lat/lon region, used to ask "what's in this area?" —
// e.g. fetching road data for the currently visible part of the map.

public struct BoundingBox: Codable, Hashable, Sendable {
    public let minLatitude: Double
    public let minLongitude: Double
    public let maxLatitude: Double
    public let maxLongitude: Double

    public init(
        minLatitude: Double,
        minLongitude: Double,
        maxLatitude: Double,
        maxLongitude: Double
    ) {
        self.minLatitude = minLatitude
        self.minLongitude = minLongitude
        self.maxLatitude = maxLatitude
        self.maxLongitude = maxLongitude
    }
}
