// Turns a Road into a RoadScore. This is where scoring logic lives and grows.

import SharedModels

/// Computes a 0...10 quality score for a road.
///
/// Currently based on surface type alone. As community reports and
/// sensor-based roughness data become available, those signals should
/// be blended in here rather than in the callers.
public struct RoadScoreCalculator: Sendable {
    public init() {}

    public func score(for road: Road) -> RoadScore {
        let base = baseScore(for: road.surface)
        let confidence: RoadScore.Confidence = road.surface == .unknown ? .low : .medium
        return RoadScore(value: base, confidence: confidence)
    }

    private func baseScore(for surface: SurfaceType) -> Double {
        switch surface {
        case .asphalt: return 9.0
        case .concrete: return 8.0
        case .cobblestone: return 6.0
        case .gravel: return 5.0
        case .dirt: return 3.0
        case .sand: return 2.0
        case .unknown: return 4.0
        }
    }
}
