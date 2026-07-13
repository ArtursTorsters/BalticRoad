// Runs Feature views in a plain macOS window, so they can be checked visually
// with `swift run BalticRoadAtlasPreview` — no Xcode/Simulator needed.

import MapFeature
import SwiftUI

@main
struct BalticRoadAtlasPreviewApp: App {
    // iPhone 15 logical point size — used as the window's starting size;
    // the window itself stays freely resizable so you can drag it bigger.
    private static let phoneSize = CGSize(width: 393, height: 882)

    var body: some Scene {
        WindowGroup("Baltic Road Atlas — Preview") {
            PhoneFrame {
                MapView(viewModel: MapViewModel())
            }
            .frame(
                idealWidth: Self.phoneSize.width,
                idealHeight: Self.phoneSize.height
            )
        }
    }
}
