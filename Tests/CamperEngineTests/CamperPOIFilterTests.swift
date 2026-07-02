// Tests for filtering camper POIs by amenity.

import Testing
import SharedModels
@testable import CamperEngine

@Test func poiListRequiresAllRequestedAmenities() {
    let coordinate = Coordinate(latitude: 0, longitude: 0)
    let full = CamperPOI(id: "1", name: "Full", coordinate: coordinate, amenities: [.overnightParking, .toilet])
    let partial = CamperPOI(id: "2", name: "Partial", coordinate: coordinate, amenities: [.overnightParking])

    let result = CamperPOIFilter().poiList([full, partial], containingAll: [.overnightParking, .toilet])

    #expect(result.map(\.id) == ["1"])
}
