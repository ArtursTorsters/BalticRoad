// The map screen: an interactive MapKit view driven by MapViewModel.

import MapKit
import SwiftUI

public struct MapView: View {
    @Bindable var viewModel: MapViewModel

    public init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Map(position: $viewModel.cameraPosition) {
            UserAnnotation()
        }
        .mapControls {
            MapCompass()
            MapScaleView()
        }
    }
}
