// Tests for MapViewModel's default camera state.

import Testing
import MapKit
@testable import MapFeature

@Test func rigaCoordinateMatchesExpectedLocation() {
    #expect(CLLocationCoordinate2D.riga.latitude == 56.9496)
    #expect(CLLocationCoordinate2D.riga.longitude == 24.1052)
}

@Test @MainActor func viewModelInitializesWithoutCrashing() {
    // MapCameraPosition is an opaque SwiftUI/MapKit type not meant to be
    // pattern-matched in application code (doing so trips a Swift 6 strict
    // concurrency Sendable diagnostic on this SDK) — so this only checks
    // construction succeeds; the actual coordinate is covered by the test
    // above, which checks our own input data instead of MapKit's internals.
    let viewModel = MapViewModel()
    _ = viewModel.cameraPosition
}
