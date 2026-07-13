// Holds the map's camera state, independent of how it's displayed.

import MapKit
import Observation
import SwiftUI

@MainActor
@Observable
public final class MapViewModel {
    public var cameraPosition: MapCameraPosition

    public init(
        centeredOn coordinate: CLLocationCoordinate2D = .riga,
        spanMeters: CLLocationDistance = 400_000
    ) {
        self.cameraPosition = .region(
            MKCoordinateRegion(
                center: coordinate,
                latitudinalMeters: spanMeters,
                longitudinalMeters: spanMeters
            )
        )
    }
}

extension CLLocationCoordinate2D {
    public static let riga = CLLocationCoordinate2D(latitude: 56.9496, longitude: 24.1052)
}
