// Tests for the road scoring engine.

import Testing
import SharedModels
@testable import RoadScoring

@Test func asphaltScoresHigherThanGravel() {
    let calculator = RoadScoreCalculator()
    let asphalt = Road(id: "1", name: "Asphalt Road", surface: .asphalt, coordinates: [])
    let gravel = Road(id: "2", name: "Gravel Road", surface: .gravel, coordinates: [])

    #expect(calculator.score(for: asphalt).value > calculator.score(for: gravel).value)
}

@Test func unknownSurfaceHasLowConfidence() {
    let calculator = RoadScoreCalculator()
    let road = Road(id: "1", name: "Mystery Road", surface: .unknown, coordinates: [])

    #expect(calculator.score(for: road).confidence == .low)
}
