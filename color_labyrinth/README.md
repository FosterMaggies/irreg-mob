# Color Labyrinth

A minimal Flutter puzzle: navigate a grid maze where doors only open if your player is the same color. Change color by stepping on colored tiles. Optional extras include keys/locks and teleporters.

## Run

Flutter SDK is required. If you don't have it yet, you can still browse the code.

```bash
# from the project root
flutter pub get
flutter run -d chrome    # Web
# or
flutter run -d android   # Android (emulator/device)
```

## Controls
- Arrow keys on desktop/web
- Swipe on touch devices
- On-screen D-Pad buttons

## Level Editing
Levels are ASCII arrays in `lib/main.dart`, `_levels`. Legend:
- `#`: wall
- `.`: empty
- `E`: exit/goal
- `R`,`G`,`B`: color tiles
- `r`,`g`,`b`: doors of each color
- `T`,`U`: teleporter pair A/B
- `K`: key pickup (single-use)
- `L`: lock (consumes key)
- `P`: player start

Each string row must be the same length. Keep boundaries walled to avoid out-of-bounds.

## Ideas to Expand
- Patrol enemies that block tiles on a timer
- Pressure plates that toggle doors
- Move counters or par par score per level
- Multi-keys with inventory UI
- Level select menu and persistence
