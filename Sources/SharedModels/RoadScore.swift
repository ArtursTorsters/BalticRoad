// The 0-10 quality score assigned to a road, plus how confident we are in it.

public struct RoadScore: Codable, Sendable {
    public enum Confidence: String, Codable, Sendable {
        case low
        case medium
        case high
    }

    /// 0...10, higher is better.
    public let value: Double
    public let confidence: Confidence

    public init(value: Double, confidence: Confidence) {
        self.value = value
        self.confidence = confidence
    }
}
