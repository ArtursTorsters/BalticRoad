// The real iOS app entry point (Phase 2). Composes Feature libraries built
// in the Sources/ SPM packages — it owns navigation between them, not
// feature logic itself.

import MapFeature
import SwiftUI

@main
struct BalticRoadAtlasAppApp: App {
    var body: some Scene {
        WindowGroup {
            MapView(viewModel: MapViewModel())
        }
    }
}
