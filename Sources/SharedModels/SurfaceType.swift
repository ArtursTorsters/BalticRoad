// The physical surface a road is made of (asphalt, gravel, dirt, ...).
// Drives the road quality score and the map's surface-color layer.

public enum SurfaceType: String, Codable, Sendable, CaseIterable {
    case asphalt
    case concrete
    case cobblestone
    case gravel
    case dirt
    case sand
    case unknown
}
