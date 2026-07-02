// A point of interest relevant to camper/van travel (parking, water, toilets, ...)
// and the amenities it offers.

import SharedModels

public enum CamperAmenity: String, Codable, Sendable, CaseIterable {
    case overnightParking
    case campsite
    case toilet
    case shower
    case drinkingWater
    case wasteDisposal
    case electricity
}

public struct CamperPOI: Identifiable, Codable, Sendable {
    public let id: String
    public let name: String
    public let coordinate: Coordinate
    public let amenities: Set<CamperAmenity>

    public init(id: String, name: String, coordinate: Coordinate, amenities: Set<CamperAmenity>) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.amenities = amenities
    }
}
