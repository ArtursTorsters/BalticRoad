// Talks to the Overpass API to fetch OpenStreetMap data (roads, surfaces, POIs).

import Foundation
import SharedModels

/// Thin wrapper around the Overpass API used to query OpenStreetMap data
/// (roads, surface tags, POIs) for the Baltic region.
public struct OverpassClient: Sendable {
    public enum ClientError: Error {
        case invalidResponse
    }

    private let session: URLSession
    private let endpoint: URL

    public init(
        session: URLSession = .shared,
        endpoint: URL = URL(string: "https://overpass-api.de/api/interpreter")!
    ) {
        self.session = session
        self.endpoint = endpoint
    }

    /// Runs a raw Overpass QL query and returns the response body.
    public func run(query: String) async throws -> Data {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.httpBody = Data("data=\(query)".utf8)

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw ClientError.invalidResponse
        }
        return data
    }

    /// Fetches every road inside the given region, decoded into our own
    /// Road model — the entry point the rest of the app should use.
    public func fetchRoads(in box: BoundingBox) async throws -> [Road] {
        let data = try await run(query: RoadQuery.roadsInBoundingBox(box))
        let response = try JSONDecoder().decode(OverpassResponse.self, from: data)
        return response.elements.map { $0.toRoad() }
    }
}
