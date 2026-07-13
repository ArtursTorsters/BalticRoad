# Baltic Road Atlas

An iOS-first road intelligence app for the Baltic countries — 🇱🇻 Latvia, 🇱🇹 Lithuania, 🇪🇪 Estonia.

Baltic Road Atlas doesn't compete with Google Maps or Apple Maps as a turn-by-turn
navigator. It's the layer you check *before* or *during* a trip to answer the
question those apps don't: **is this road worth driving?**

Is it asphalt or gravel? In good condition? Fine for a camper? Where can I park
overnight, refill water, find a toilet, or see something interesting along the way?

## Who it's for

- **Primary:** camper owners, vanlifers, motorcyclists, road-trip travelers
- **Secondary:** everyday drivers, tourists, caravan owners, cyclists

## Core features

- **Road Quality Score** — every road gets a 0–10 score derived from OSM surface/smoothness
  tags, community reports, and (eventually) sensor-based vibration data.
- **Road Surface Layer** — map roads colored by surface: asphalt, concrete, gravel, dirt,
  sand, cobblestone.
- **Camper Mode** — overnight parking, campsites, toilets, showers, water, waste disposal,
  electricity; routing that eventually avoids dirt roads, low bridges, weight/width limits.
- **Community Reports** — potholes, construction, flooding, closures, gravel sections,
  hazards; reports expire unless confirmed by others.
- **Baltic Way Route** — a historical drive along the 1989 Baltic Way, with monuments,
  memorials, photos, and (future) audio guides.
- **Scenic Routes** — community-rated coastal drives, forest roads, motorcycle routes,
  camper-friendly roads, hidden gems.
- **Offline Mode** — download Latvia, Lithuania, and Estonia for offline use.

See [CLAUDE.md](CLAUDE.md) for architecture, conventions, and current build status.

## Data sources

- **OpenStreetMap** (via the Overpass API) — roads, surface types, smoothness, parking,
  campsites, toilets, water points, fuel stations.
- **Community reports** — user-submitted, becomes a proprietary dataset over time.
- **Government open data** (future) — roadworks, closures, maintenance.

## Tech stack

| Layer | Choice |
|---|---|
| Platform | iOS (initially) |
| Language | Swift 6 |
| UI | SwiftUI |
| Maps | MapKit (MapLibre later if needed) |
| Architecture | MVVM, feature-based modules |
| Backend (later) | Supabase (auth, Postgres, reports, favorites, sync) |
| Local storage | SwiftData (or SQLite if needed) |
| Networking | URLSession |

## Current status

No Xcode yet (disk space), so the project starts as a pure **Swift Package Manager**
workspace: core logic first, SwiftUI app once Xcode is available. See the
[roadmap](CLAUDE.md#roadmap) for phases.

### Folder structure

Each `Sources/<Name>` folder is its own target — a library (testable, reusable code:
`SharedModels`, `OSMClient`, `RoadScoring`, `CamperEngine`, `HistoricalRoutes`,
`MapFeature`) or an executable (`BalticRoadAtlasCLI`, `BalticRoadAtlasPreview`).
`Tests/<Name>Tests` holds a library's tests. `SharedModels` has no dependencies —
every other library depends on it, never the other way round.

```
BalticRoadAtlas/
├── Package.swift                  # declares every target below and how they depend on each other
├── README.md                      # this file
├── CLAUDE.md                      # architecture/conventions notes for AI agents working here
│
├── Sources/
│   ├── SharedModels/              # shared data types — no dependencies, everything else depends on this
│   │   ├── Coordinate.swift          # a latitude/longitude pair
│   │   ├── SurfaceType.swift         # asphalt / gravel / dirt / ... enum
│   │   ├── Road.swift                # a road: id, name, surface, path
│   │   └── RoadScore.swift           # a 0–10 score + confidence level
│   │
│   ├── OSMClient/                 # talks to OpenStreetMap
│   │   └── OverpassClient.swift      # fetches road/POI data from the Overpass API
│   │
│   ├── RoadScoring/                # the "is this road worth driving" engine
│   │   └── RoadScoreCalculator.swift # turns a Road into a RoadScore
│   │
│   ├── CamperEngine/               # camper-specific logic
│   │   ├── CamperPOI.swift           # a camper point of interest (parking, water, toilets, ...)
│   │   └── CamperPOIFilter.swift     # filters POIs by which amenities they have
│   │
│   ├── HistoricalRoutes/           # the Baltic Way feature
│   │   └── BalticWayRoute.swift      # historical waypoints along the 1989 Baltic Way
│   │
│   ├── MapFeature/                 # the map screen (View + ViewModel, MVVM)
│   │   ├── MapView.swift             # SwiftUI view: an interactive MapKit map
│   │   └── MapViewModel.swift        # holds the map's camera state
│   │
│   ├── BalticRoadAtlasCLI/         # temporary stand-in for the SwiftUI app
│   │   └── main.swift                # entry point — run with `swift run BalticRoadAtlasCLI`
│   │
│   └── BalticRoadAtlasPreview/     # dev tool: see Feature views without Xcode
│       ├── BalticRoadAtlasPreviewApp.swift  # entry point — `swift run BalticRoadAtlasPreview`
│       └── PhoneFrame.swift                 # wraps a view at iPhone size + bezel
│
└── Tests/
    ├── SharedModelsTests/
    ├── OSMClientTests/
    ├── RoadScoringTests/
    ├── CamperEngineTests/
    ├── HistoricalRoutesTests/
    └── MapFeatureTests/
```

## Getting started

Requires Swift 6 (`swift --version`). No Xcode required for this stage.

```bash
swift build              # build all packages
swift test                # run the test suite
swift run BalticRoadAtlasCLI   # run the CLI smoke test
```
