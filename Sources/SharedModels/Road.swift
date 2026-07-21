// A single road: its identity, name, surface, and the points that trace its path.

public struct Road: Identifiable, Codable, Sendable {
    public let id: String
    // Many real roads (rural tracks, forest paths) have no OSM `name` tag at all.
    public let name: String?
    public let surface: SurfaceType
    public let coordinates: [Coordinate]

    public init(id: String, name: String?, surface: SurfaceType, coordinates: [Coordinate]) {
        self.id = id
        self.name = name
        self.surface = surface
        self.coordinates = coordinates
    }
}
