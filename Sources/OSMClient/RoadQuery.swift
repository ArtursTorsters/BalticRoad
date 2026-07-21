// Builds Overpass QL query strings for fetching road data. Pure text
// building — no networking here, that's OverpassClient's job.

import SharedModels

public enum RoadQuery {
    public static func roadsInBoundingBox(_ box: BoundingBox) -> String {
        """
        [out:json][timeout:25];
        way["highway"](\(box.minLatitude),\(box.minLongitude),\(box.maxLatitude),\(box.maxLongitude));
        out geom;
        """
    }
}
