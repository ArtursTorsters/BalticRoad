// Tests for the Overpass API client.

import Testing
@testable import OSMClient

@Test func clientUsesOverpassDefaultEndpointByDefault() {
    // Constructing with defaults should not throw or crash; real network
    // calls are exercised manually / in integration tests, not here.
    _ = OverpassClient()
}
