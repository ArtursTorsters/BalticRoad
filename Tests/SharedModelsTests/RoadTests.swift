// Tests for the Road model.

import Testing
@testable import SharedModels

@Test func roadRetainsProvidedSurface() {
    let road = Road(id: "1", name: "Test Road", surface: .gravel, coordinates: [])
    #expect(road.surface == .gravel)
}
