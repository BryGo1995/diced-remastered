# Codebase Refactor & Cleanup Design

**Date:** 2026-03-28
**Branch:** refactor
**Scope:** Option B — File reorganization + light code cleanup

---

## Goal

Reorganize the diced-remastered codebase into a logical, industry-standard Godot 4 structure. Remove unused files, fix code quality issues, and lay the groundwork for JSON-driven board and dice configurations.

---

## 1. File Deletions

These files are orphaned or empty stubs with no references in the active game:

| File | Reason |
|------|--------|
| `scenes/dice.gd` | Old CharacterBody2D impl, replaced by base_dice |
| `scenes/dice.tscn` | Same as above |
| `scenes/game_board.gd` | Procedural board generator, never integrated |
| `scenes/game_board.tscn` | Same as above |
| `scenes/tile.gd` | Only used by game_board (also deleted) |
| `scenes/tile.tscn` | Same as above |
| `scenes/UI/game_config.gd` | Empty stub, not wired into any scene |
| `scenes/UI/game_config.tscn` | Same as above |
| `fonts/` | Empty directory |

---

## 2. Final Folder Structure

Scripts co-located with their scenes (Godot community standard). All paths relative to project root.

```
diced-remastered/
├── project.godot
├── icon.svg
├── LICENSE.md
├── README.md
├── addons/
│   └── godot-vim/
├── assets/
│   └── sprites/
│       ├── basic-diced-tileset.png
│       ├── d6-white/
│       ├── d8-blue/
│       ├── d10-gr/
│       └── d12-red/
├── autoload/
│   └── config_loader.gd
├── data/
│   ├── boards/
│   │   └── standard.json
│   └── dice/
│       ├── d6_basic.json
│       ├── d8_basic.json
│       └── d10_basic.json
└── scenes/
    ├── game/
    │   ├── board_map.gd
    │   ├── board_map.tscn
    │   ├── dice_container.gd
    │   ├── main.gd
    │   └── main.tscn
    ├── dice/
    │   ├── base_dice.gd
    │   ├── base_dice.tscn
    │   ├── dice_eight.gd
    │   ├── dice_eight.tscn
    │   ├── dice_six.gd
    │   ├── dice_six.tscn
    │   ├── dice_ten.gd      ← new
    │   └── dice_ten.tscn
    └── ui/
        ├── game_over_menu.gd
        ├── game_over_menu.tscn
        ├── hud.gd
        ├── hud.tscn
        ├── main_menu.gd
        └── main_menu.tscn
```

---

## 3. File Moves

All internal scene/script `res://` references must be updated after each move.

| From | To |
|------|----|
| `board_map.gd` | `scenes/game/board_map.gd` |
| `board_map.tscn` | `scenes/game/board_map.tscn` |
| `scenes/main.gd` | `scenes/game/main.gd` |
| `scenes/main.tscn` | `scenes/game/main.tscn` |
| `scenes/dice_container.gd` | `scenes/game/dice_container.gd` |
| `scenes/hud.gd` | `scenes/ui/hud.gd` |
| `scenes/hud.tscn` | `scenes/ui/hud.tscn` |
| `scenes/main_menu.gd` | `scenes/ui/main_menu.gd` |
| `scenes/main_menu.tscn` | `scenes/ui/main_menu.tscn` |
| `scenes/game_over_menu.gd` | `scenes/ui/game_over_menu.gd` |
| `scenes/game_over_menu.tscn` | `scenes/ui/game_over_menu.tscn` |
| `scenes/base_dice.gd` | `scenes/dice/base_dice.gd` |
| `scenes/base_dice.tscn` | `scenes/dice/base_dice.tscn` |
| `scenes/dice_six.gd` | `scenes/dice/dice_six.gd` |
| `scenes/dice_six.tscn` | `scenes/dice/dice_six.tscn` |
| `scenes/dice_eight.gd` | `scenes/dice/dice_eight.gd` |
| `scenes/dice_eight.tscn` | `scenes/dice/dice_eight.tscn` |
| `scenes/dice_ten.tscn` | `scenes/dice/dice_ten.tscn` |
| `sprites/` | `assets/sprites/` |

---

## 4. New Files

### `scenes/dice/dice_ten.gd`
Mirrors `dice_six.gd` and `dice_eight.gd`. Extends `base_dice` with no overrides (same pattern as siblings). Assigns the script to `dice_ten.tscn`.

### `autoload/config_loader.gd`
Godot AutoLoad singleton. Stub for now — registers in `project.godot` as `ConfigLoader`. Will be the single entry point for loading board and dice JSON configs in future work.

### `data/boards/standard.json`
Encodes the current hardcoded board layout (5 columns × 4 rows, 20 dice). Format:
```json
{
  "id": "standard",
  "grid": { "columns": 5, "rows": 4 },
  "dice": [
    { "dice_id": "d6_basic", "position": [0, 0] },
    ...
  ]
}
```

### `data/dice/d6_basic.json`, `d8_basic.json`, `d10_basic.json`
Encodes the current dice types. Format:
```json
{
  "id": "d6_basic",
  "sides": 6,
  "sprite_folder": "d6-white",
  "abilities": []
}
```

> Note: The game does not yet read these JSON files at runtime — they are data stubs that document the current configuration and serve as the foundation for the config loading system.

---

## 5. Code Fixes

| File | Fix |
|------|-----|
| `board_map.gd` | Rename enum `Tile_State` → `TileState` |
| `board_map.gd` | Remove dead `pass` after `update_tile_sprites()` call |
| `hud.gd` | Remove dead `pass # Replace with function body` |
| `hud.tscn` | Clear "Test Message" from the Message label text |

---

## 6. project.godot Updates

- Update `run/main_scene` path from `res://scenes/main_menu.tscn` to `res://scenes/ui/main_menu.tscn`
- Register `autoload/config_loader.gd` as AutoLoad singleton named `ConfigLoader`
- Update any other internal path references

---

## Out of Scope

- Runtime JSON loading (config_loader reads files at runtime) — future work
- Replacing hardcoded dice positions with layout containers
- Refactoring tile state storage from index-array to Dictionary
- Implementing game end conditions
- D12 dice completion

---

## Success Criteria

- Project opens in Godot 4 without errors
- Main menu → gameplay → game over flow works as before
- No orphaned or misplaced files remain
- All `.gd` files pass Godot's script parser without errors
