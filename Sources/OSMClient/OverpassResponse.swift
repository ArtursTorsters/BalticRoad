// Mirrors the shape of Overpass's JSON response. Kept internal and
// separate from our own Road/Coordinate models (SharedModels) so a change
// in Overpass's wire format only ever touches this one file.

struct OverpassResponse: Decodable {
    let elements: [OverpassElement]
}

struct OverpassElement: Decodable {
    let id: Int
    let geometry: [OverpassGeometryPoint]
    let tags: [String: String]
}

struct OverpassGeometryPoint: Decodable {
    let lat: Double
    let lon: Double
}
