# OSM data coverage: surface & smoothness tags in the Baltics

Researched 2026-10-11, prompted by a side discussion about whether a
vehicle-profile-aware routing app idea already existed — it does, as this
project's own [issue #2](https://github.com/ArtursTorsters/BalticRoad/issues/2)
("Vehicle Profile Routing engine"), already scoped via #18/#19/#20/#21/#22/#30/#57.
Before building any of that, the open question was: **how much of the Baltic
road network actually carries the OSM tags the whole product depends on**
(`surface=*`, `smoothness=*`)? This hadn't been measured — `OverpassElement+Road.swift`
still hardcodes `surface` to `.unknown` (issue #14 is the real mapping, not built
yet), so no part of the codebase had touched real tag coverage either.

## Methodology

Queried the [ohsome API](https://docs.ohsome.org/ohsome-api/stable/) (a
dedicated OSM statistics service built on full edit history, chosen over
hitting the public Overpass mirrors directly — those returned repeated
"server too busy" errors during this research and ohsome is the
better-suited tool for aggregate counts anyway) for each country's bounding
box, snapshot `2026-07-27` (most recent available at query time):

```
GET https://api.ohsome.org/v1/elements/count
    ?bboxes=<minlon,minlat,maxlon,maxlat>
    &filter=highway in (motorway, trunk, primary, secondary, tertiary,
                        unclassified, residential, track, service)
             and geometry:line [and surface=* | and smoothness=*]
    &time=2026-07-27
```

**Caveat**: bounding boxes, not exact country polygons (the ones `regions.sql`
analogues would use in a PostGIS-backed project) — these are the same kind of
"close to real, not pixel-perfect" bounds OpenSky's own box uses (see the
sibling `balticwatch` project). Good enough to see the shape of the problem,
not precise enough to cite as an exact percentage anywhere user-facing.

## Headline numbers

| Country   | Vehicle-relevant roads | `surface=*` coverage | `smoothness=*` coverage |
| --------- | ----------------------:| ---------------------:| ------------------------:|
| Latvia    | 469,962                | 34.1%                  | 3.9%                     |
| Lithuania | 599,550                | 39.8%                  | 1.4%                     |
| Estonia   | 273,816                | 32.8%                  | 2.5%                     |

("Vehicle-relevant" = `highway` in motorway/trunk/primary/secondary/tertiary/
unclassified/residential/track/service — excludes footways, cycleways, paths,
steps.)

## The real story is per-class, not the aggregate

Breaking Latvia down by `highway` class shows the aggregate number hides the
actual shape of the problem:

| `highway=` class | total ways | `surface=*` coverage |
| ----------------- | ----------:| ----------------------:|
| motorway           | 57          | 100.0%                 |
| trunk               | 6,220       | 99.6%                  |
| primary             | 10,407      | 97.5%                  |
| secondary           | 15,129      | 89.5%                  |
| tertiary            | 11,059      | 88.9%                  |
| unclassified        | 52,260      | 51.5%                  |
| residential         | 50,177      | 50.8%                  |
| **track**           | **97,007**  | **16.2%**               |
| service             | 227,646     | 23.1%                   |

The classes that are almost universally surface-tagged (motorway through
tertiary) are also almost universally paved already — knowing their surface
tells a driver nothing they couldn't assume. The one class where "is this
road worth driving" is a genuinely open question — `track`, 97k ways in
Latvia alone, exactly the farm/forest roads a camper or road-tripper would
want scored — is tagged barely one time in six. `smoothness` (actual
condition/roughness, not just material) is close to absent everywhere,
single digits across all three countries.

## What this means for the project

- **`RoadScoreCalculator` must treat a missing tag as "unknown," never as an
  implicit "fine."** Silently defaulting an untagged `track` to a decent
  score would be actively misleading for the exact roads the app exists to
  de-risk. This is what issue #24 ("Define confidence-level rules") and #16
  ("Fallback styling for roads with unknown surface") already exist to
  settle — this data is the concrete argument for why they matter, not an
  abstract edge case.
- **Vehicle Profile Routing (#2) can't lean on `surface`/`smoothness` tags
  alone for the roads where profile actually matters.** A Jeep-vs-Mini-Cooper
  routing decision is most relevant exactly on `track`/`unclassified` roads —
  the same ~84% of `track` ways with no `surface` tag at all. Worth deciding
  explicitly (not silently defaulting) how #21's "Road-segment filter: profile
  vs SurfaceType" should treat an *untagged* `track`: avoid it for a
  low-clearance profile on the assumption that untagged track probably means
  unpaved/unmaintained, or exclude it from scoring entirely until proven
  otherwise? Real tradeoff either way — false caution annoys users with a
  capable vehicle, false confidence sends a Mini Cooper down a farm road.
- **This is the actual argument for #8/#49-51** (accelerometer+GPS telemetry →
  roughness signal → score adjustment) being a real, not speculative, phase —
  tag-based scoring structurally cannot cover the roads that matter most here,
  so a sensor-based signal is filling a real gap, not gold-plating.

## Reproducing this

```bash
curl -s -G "https://api.ohsome.org/v1/elements/count" \
  --data-urlencode "bboxes=20.97,55.67,28.24,58.09" \
  --data-urlencode "filter=highway=track and geometry:line and surface=*" \
  --data-urlencode "time=2026-07-27"
```

Swap `bboxes` for Lithuania (`20.94,53.90,26.84,56.45`) or Estonia
(`21.76,57.52,28.21,59.68`), or the `highway=` class, to check any other cut.
Re-run before relying on these numbers for a real product decision — OSM
coverage changes continuously, and this snapshot will age.
