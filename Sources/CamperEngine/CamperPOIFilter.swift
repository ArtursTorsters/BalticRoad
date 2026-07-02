// Filters a list of camper POIs down to the ones that have every amenity you need.

public struct CamperPOIFilter: Sendable {
    public init() {}

    public func poiList(_ pois: [CamperPOI], containingAll required: Set<CamperAmenity>) -> [CamperPOI] {
        pois.filter { required.isSubset(of: $0.amenities) }
    }
}
