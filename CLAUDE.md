# CLAUDE.md

Guidance for Claude Code (or any agent) working in this repository.

## What this is

Baltic Road Atlas is an iOS road-intelligence app for Latvia, Lithuania, and Estonia.
It answers "is this road worth driving?" — surface type, condition, camper-friendliness,
overnight parking, water/toilets, and historical points of interest — rather than
competing with Google/Apple Maps on turn-by-turn navigation. Full product vision lives
in [README.md](README.md).

## Guiding principle

The app is a road intelligence companion, not a navigator replacement. When a feature
request is ambiguous, prefer the interpretation that helps someone decide *which* road
to take or *what's nearby*, over one that duplicates existing turn-by-turn nav.

## Current phase

**Phase 1 — core engine, no Xcode.** Xcode isn't installed yet (disk space), so
everything is built as Swift Package Manager libraries with a CLI target
(`BalticRoadAtlasCLI`) standing in for the app during development.

SwiftUI and MapKit code is fine to write now — both frameworks are part of the macOS
SDK that ships with Command Line Tools, so a `.macOS(.v14)` executable target can
`import SwiftUI` / `import MapKit` and run as a real window via `swift run`, no Xcode
required. What's *not* available without Xcode: the iOS SDK/simulator, Xcode's live
Preview canvas, and UIKit. So feature code (views, view models, MapKit usage) can be
built and manually verified via a macOS preview host now; the actual iOS app target
and on-device/simulator behavior wait for Phase 2. Keep feature logic in library
targets that don't hard-code macOS-only assumptions, so the same code slots into the
iOS app later without rework.

When Xcode becomes available, Phase 2 adds a real iOS app target that imports these
packages; the CLI target can stay as a scripting/debugging tool.

## Roadmap

1. **Core engine** *(current)* — package structure, shared models, road scoring,
   OSM client, Baltic Way dataset.
2. **iOS app shell** — SwiftUI interface, MapKit integration, interactive map (needs Xcode).
3. **Feature build-out** — Camper mode, historical routes, parking, community reports.
4. **Backend** — Supabase: auth, accounts, saved routes, favorites, crowdsourced reports.
5. **Proprietary features** — automatic sensor-based road scoring, offline maps, AI route
   suggestions.

## Architecture

MVVM, feature-based, once the SwiftUI app exists:

```
View → ViewModel → Service → Data Source
```

Coming from React: there's no hooks/context equivalent to reach for. A SwiftUI `View`
is not a component with hooks — state lives in the `ViewModel`, data access lives in a
`Service`, and the `Model` is a plain `struct`. Don't recreate React patterns (heavy
hooks usage, global context-as-store); use small, focused services and protocols for
abstraction/testing instead.

## Package layout

```
Sources/
  SharedModels/          Road, Coordinate, SurfaceType, RoadScore — no dependencies
  OSMClient/             Overpass API client → depends on SharedModels
  RoadScoring/           road quality scoring engine → depends on SharedModels
  CamperEngine/          camper POIs, amenity filtering → depends on SharedModels
  HistoricalRoutes/      Baltic Way waypoints/dataset → depends on SharedModels
  MapFeature/            map screen (View + ViewModel) → depends on SharedModels (once it needs Road data)
  BalticRoadAtlasCLI/    CLI entry point wiring the above together
  BalticRoadAtlasPreview/  macOS window that hosts Feature views for manual
                           verification without Xcode (see "Previewing" below)
Tests/
  <Target>Tests/         one test target per library target
```

Keep `SharedModels` dependency-free — every other module depends on it, so pulling in
networking or scoring logic there creates cycles. New domain logic goes in its own
target under `Sources/`, mirroring an existing one, with a matching `Tests/*Tests`
target — don't grow `BalticRoadAtlasCLI` into a dumping ground for logic that belongs
in a library target.

Feature libraries (`MapFeature` and whatever follows it — RoadScore, Camper, Reports,
HistoricalRoutes, Search, Settings) already live under `Sources/` today, each its own
SwiftUI-capable target following View → ViewModel → Service → Model. Once Xcode is
available, the real iOS app target imports these directly — it composes them (tab bar,
navigation) rather than owning their internals. `Core/`, `Shared/`, `Networking/`,
`Database/` follow standard iOS-app conventions at that point, for genuinely
app-shell-only concerns (app entry point, cross-feature navigation).

## Previewing without Xcode

SwiftUI and MapKit both work as plain macOS code (see "Current phase" above).
`BalticRoadAtlasPreview` is a throwaway executable target that hosts one Feature view
in a phone-shaped, resizable window so you can see it: `swift run BalticRoadAtlasPreview`.
When adding a new Feature view, wire it into `BalticRoadAtlasPreviewApp.swift` instead
of building a new preview host each time. This only proves the view builds and lays out
correctly on macOS — it doesn't substitute for checking on iOS once Xcode exists
(no iOS chrome, no touch gestures, no on-device quirks).

## Conventions

- **Models are `struct`s**, `Codable` + `Sendable` where they cross module or async
  boundaries (see `SharedModels`).
- **Swift 6 strict concurrency** is on (`swift-tools-version: 6.0`) — new types that
  cross task boundaries need to be `Sendable` or explicitly isolated; don't silence
  concurrency warnings without understanding why they fired.
- **Tests use Swift Testing** (`import Testing`, `@Test`, `#expect`), not XCTest —
  match the existing test files' style.
- **Networking** is native `URLSession` (see `OSMClient/OverpassClient.swift`) — no
  networking libraries.
- Favor protocols at module boundaries only where there's an actual second
  implementation or test double planned (e.g. a mock Overpass client for tests) — not
  speculatively.

## Commands

```bash
swift build                     # build all targets
swift test                      # run all tests
swift run BalticRoadAtlasCLI    # run the CLI smoke test
Scripts/swiftlint.sh lint       # lint (rules in .swiftlint.yml)
Scripts/swiftlint.sh lint --fix # autocorrect what SwiftLint can fix
```

No Xcode project exists yet — everything above runs from the CLI via SPM.

Use `Scripts/swiftlint.sh` instead of a bare `swiftlint` call: this machine only has
Command Line Tools (no full Xcode), and the wrapper sets `DYLD_FRAMEWORK_PATH` so
SwiftLint can find `sourcekitd` — plain `swiftlint` crashes without it. The VS Code
SwiftLint extension is already pointed at the same wrapper via `.vscode/settings.json`.
