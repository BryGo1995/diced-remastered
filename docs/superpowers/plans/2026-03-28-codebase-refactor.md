# Codebase Refactor & Cleanup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorganize the diced-remastered Godot 4 project into a clean, domain-separated folder structure, remove orphaned files, add JSON config stubs, and fix code quality issues.

**Architecture:** Files are organized into `scenes/game/`, `scenes/dice/`, and `scenes/ui/` by domain. Sprites move to `assets/sprites/`. A `data/` folder holds JSON configs. An `autoload/config_loader.gd` singleton stubs the future config loading system. All `res://` paths in `.tscn` and `.gd` files are updated via `sed` after moves.

**Tech Stack:** Godot 4.5, GDScript, Git Bash on Windows

---

## File Map

**Deleted:**
- `scenes/dice.gd`, `scenes/dice.tscn`
- `scenes/game_board.gd`, `scenes/game_board.tscn`
- `scenes/tile.gd`, `scenes/tile.tscn`
- `scenes/UI/game_config.gd`, `scenes/UI/game_config.tscn`
- `fonts/`

**Moved:**
- `board_map.gd` → `scenes/game/board_map.gd`
- `board_map.tscn` → `scenes/game/board_map.tscn`
- `sprites/` → `assets/sprites/`
- `scenes/main.gd` → `scenes/game/main.gd`
- `scenes/main.tscn` → `scenes/game/main.tscn`
- `scenes/dice_container.gd` → `scenes/game/dice_container.gd`
- `scenes/base_dice.gd` → `scenes/dice/base_dice.gd`
- `scenes/base_dice.tscn` → `scenes/dice/base_dice.tscn`
- `scenes/dice_six.gd` → `scenes/dice/dice_six.gd`
- `scenes/dice_six.tscn` → `scenes/dice/dice_six.tscn`
- `scenes/dice_eight.gd` → `scenes/dice/dice_eight.gd`
- `scenes/dice_eight.tscn` → `scenes/dice/dice_eight.tscn`
- `scenes/dice_ten.tscn` → `scenes/dice/dice_ten.tscn`
- `scenes/hud.gd` → `scenes/ui/hud.gd`
- `scenes/hud.tscn` → `scenes/ui/hud.tscn`
- `scenes/main_menu.gd` → `scenes/ui/main_menu.gd`
- `scenes/main_menu.tscn` → `scenes/ui/main_menu.tscn`
- `scenes/game_over_menu.gd` → `scenes/ui/game_over_menu.gd`
- `scenes/game_over_menu.tscn` → `scenes/ui/game_over_menu.tscn`

**Created:**
- `scenes/dice/dice_ten.gd`
- `autoload/config_loader.gd`
- `data/boards/standard.json`
- `data/dice/d6_basic.json`
- `data/dice/d8_basic.json`
- `data/dice/d10_basic.json`

**Modified:**
- `scenes/game/board_map.gd` — rename `Tile_State` → `TileState`, remove dead `pass`
- `scenes/ui/hud.gd` — remove dead `pass`
- `scenes/ui/hud.tscn` — clear "Test Message" label
- `scenes/dice/dice_ten.tscn` — add script reference
- `project.godot` — register ConfigLoader autoload
- All `.tscn` and `.gd` files — updated `res://` paths

---

### Task 1: Delete orphaned files

**Files:** `scenes/dice.gd`, `scenes/dice.tscn`, `scenes/game_board.gd`, `scenes/game_board.tscn`, `scenes/tile.gd`, `scenes/tile.tscn`, `scenes/UI/game_config.gd`, `scenes/UI/game_config.tscn`, `fonts/`

- [ ] **Step 1: Remove orphaned files**

```bash
cd C:/Users/broni/Dev_Space/Games/GodotGames/diced-remastered
git rm scenes/dice.gd scenes/dice.tscn
git rm scenes/game_board.gd scenes/game_board.tscn
git rm scenes/tile.gd scenes/tile.tscn
git rm "scenes/UI/game_config.gd" "scenes/UI/game_config.tscn"
git rm -r fonts/
```

Expected: Each command prints `rm 'scenes/...'` per file. No errors.

- [ ] **Step 2: Commit**

```bash
git commit -m "chore: remove orphaned and unused files"
```

---

### Task 2: Create new directory structure

**Files:** New directories `scenes/game/`, `scenes/dice/`, `assets/`, `autoload/`, `data/boards/`, `data/dice/`

- [ ] **Step 1: Create directories**

```bash
mkdir -p scenes/game scenes/dice assets autoload data/boards data/dice
```

Expected: Silent success. `scenes/ui/` will be created implicitly when files are moved into it in Task 5.

---

### Task 3: Move sprite assets

- [ ] **Step 1: Move sprites directory**

```bash
git mv sprites assets/sprites
```

Expected: No output. Verify: `ls assets/` should show `sprites/`.

- [ ] **Step 2: Commit**

```bash
git add assets/
git commit -m "chore: move sprites to assets/sprites"
```

---

### Task 4: Move board_map files to scenes/game/

- [ ] **Step 1: Move files**

```bash
git mv board_map.gd scenes/game/board_map.gd
git mv board_map.tscn scenes/game/board_map.tscn
```

- [ ] **Step 2: Commit**

```bash
git commit -m "chore: move board_map to scenes/game/"
```

---

### Task 5: Move UI files to scenes/ui/

Note: On Windows, the existing `scenes/UI/` (capital) directory was removed in Task 1. `git mv` to `scenes/ui/` (lowercase) is safe.

- [ ] **Step 1: Move all UI files**

```bash
git mv scenes/hud.gd scenes/ui/hud.gd
git mv scenes/hud.tscn scenes/ui/hud.tscn
git mv scenes/main_menu.gd scenes/ui/main_menu.gd
git mv scenes/main_menu.tscn scenes/ui/main_menu.tscn
git mv scenes/game_over_menu.gd scenes/ui/game_over_menu.gd
git mv scenes/game_over_menu.tscn scenes/ui/game_over_menu.tscn
```

Expected: No output. `scenes/ui/` is created implicitly.

- [ ] **Step 2: Commit**

```bash
git commit -m "chore: move UI files to scenes/ui/"
```

---

### Task 6: Move dice files to scenes/dice/

- [ ] **Step 1: Move all dice files**

```bash
git mv scenes/base_dice.gd scenes/dice/base_dice.gd
git mv scenes/base_dice.tscn scenes/dice/base_dice.tscn
git mv scenes/dice_six.gd scenes/dice/dice_six.gd
git mv scenes/dice_six.tscn scenes/dice/dice_six.tscn
git mv scenes/dice_eight.gd scenes/dice/dice_eight.gd
git mv scenes/dice_eight.tscn scenes/dice/dice_eight.tscn
git mv scenes/dice_ten.tscn scenes/dice/dice_ten.tscn
```

- [ ] **Step 2: Commit**

```bash
git commit -m "chore: move dice scenes to scenes/dice/"
```

---

### Task 7: Move main game files to scenes/game/

- [ ] **Step 1: Move files**

```bash
git mv scenes/main.gd scenes/game/main.gd
git mv scenes/main.tscn scenes/game/main.tscn
git mv scenes/dice_container.gd scenes/game/dice_container.gd
```

- [ ] **Step 2: Commit**

```bash
git commit -m "chore: move main game files to scenes/game/"
```

---

### Task 8: Update all res:// path references

All `.tscn` and `.gd` files contain their original `res://` paths. This task updates every path to reflect the new locations. Run all commands from the project root.

**Files:** All `.tscn` and `.gd` files in the project (excluding `.godot/`)

- [ ] **Step 1: Update sprites path**

```bash
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://sprites/|res://assets/sprites/|g' {} \;
find . -name "*.gd" -not -path "./.godot/*" -exec sed -i 's|res://sprites/|res://assets/sprites/|g' {} \;
```

- [ ] **Step 2: Update board_map paths (root → scenes/game/)**

```bash
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://board_map\.tscn|res://scenes/game/board_map.tscn|g' {} \;
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://board_map\.gd|res://scenes/game/board_map.gd|g' {} \;
find . -name "*.gd" -not -path "./.godot/*" -exec sed -i 's|res://board_map\.gd|res://scenes/game/board_map.gd|g' {} \;
```

- [ ] **Step 3: Update base_dice paths**

```bash
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/base_dice\.tscn|res://scenes/dice/base_dice.tscn|g' {} \;
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/base_dice\.gd|res://scenes/dice/base_dice.gd|g' {} \;
find . -name "*.gd" -not -path "./.godot/*" -exec sed -i 's|res://scenes/base_dice\.gd|res://scenes/dice/base_dice.gd|g' {} \;
```

- [ ] **Step 4: Update dice_six, dice_eight, dice_ten paths**

```bash
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/dice_six\.tscn|res://scenes/dice/dice_six.tscn|g' {} \;
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/dice_six\.gd|res://scenes/dice/dice_six.gd|g' {} \;
find . -name "*.gd" -not -path "./.godot/*" -exec sed -i 's|res://scenes/dice_six\.gd|res://scenes/dice/dice_six.gd|g' {} \;
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/dice_eight\.tscn|res://scenes/dice/dice_eight.tscn|g' {} \;
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/dice_eight\.gd|res://scenes/dice/dice_eight.gd|g' {} \;
find . -name "*.gd" -not -path "./.godot/*" -exec sed -i 's|res://scenes/dice_eight\.gd|res://scenes/dice/dice_eight.gd|g' {} \;
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/dice_ten\.tscn|res://scenes/dice/dice_ten.tscn|g' {} \;
```

- [ ] **Step 5: Update main game file paths**

```bash
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/main\.tscn|res://scenes/game/main.tscn|g' {} \;
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/main\.gd|res://scenes/game/main.gd|g' {} \;
find . -name "*.gd" -not -path "./.godot/*" -exec sed -i 's|res://scenes/main\.tscn|res://scenes/game/main.tscn|g' {} \;
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/dice_container\.gd|res://scenes/game/dice_container.gd|g' {} \;
```

- [ ] **Step 6: Update UI file paths**

```bash
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/hud\.tscn|res://scenes/ui/hud.tscn|g' {} \;
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/hud\.gd|res://scenes/ui/hud.gd|g' {} \;
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/main_menu\.tscn|res://scenes/ui/main_menu.tscn|g' {} \;
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/main_menu\.gd|res://scenes/ui/main_menu.gd|g' {} \;
find . -name "*.gd" -not -path "./.godot/*" -exec sed -i 's|res://scenes/main_menu\.tscn|res://scenes/ui/main_menu.tscn|g' {} \;
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/game_over_menu\.tscn|res://scenes/ui/game_over_menu.tscn|g' {} \;
find . -name "*.tscn" -not -path "./.godot/*" -exec sed -i 's|res://scenes/game_over_menu\.gd|res://scenes/ui/game_over_menu.gd|g' {} \;
find . -name "*.gd" -not -path "./.godot/*" -exec sed -i 's|res://scenes/game_over_menu\.tscn|res://scenes/ui/game_over_menu.tscn|g' {} \;
```

- [ ] **Step 7: Verify no old paths remain**

```bash
grep -rn "res://sprites/" . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "res://board_map\." . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "res://scenes/base_dice" . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "res://scenes/dice_" . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "res://scenes/main\." . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "res://scenes/hud\." . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "res://scenes/main_menu\." . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "res://scenes/game_over_menu\." . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
```

Expected: All greps return no output (no old paths found).

- [ ] **Step 8: Commit path updates**

```bash
git add -A
git commit -m "chore: update all res:// paths to reflect new file structure"
```

---

### Task 9: Create dice_ten.gd and assign to scene

**Files:**
- Create: `scenes/dice/dice_ten.gd`
- Modify: `scenes/dice/dice_ten.tscn`

- [ ] **Step 1: Create dice_ten.gd**

Create `scenes/dice/dice_ten.gd` with this content:

```gdscript
extends "res://scenes/dice/base_dice.gd"


func _ready():
	super._ready()


func _process(delta):
	super._process(delta)
```

- [ ] **Step 2: Add script reference to dice_ten.tscn**

In `scenes/dice/dice_ten.tscn`:

Change the header line from:
```
[gd_scene load_steps=13 format=3 uid="uid://cccvkyav27mlj"]
```
To:
```
[gd_scene load_steps=14 format=3 uid="uid://cccvkyav27mlj"]
```

Add this line immediately after the first `[ext_resource ...]` line (the `base_dice.tscn` reference):
```
[ext_resource type="Script" path="res://scenes/dice/dice_ten.gd" id="13_dice10"]
```

Change the `[node ...]` line from:
```
[node name="DiceTen" instance=ExtResource("1_i0lng")]
```
To:
```
[node name="DiceTen" instance=ExtResource("1_i0lng")]
script = ExtResource("13_dice10")
```

- [ ] **Step 3: Commit**

```bash
git add scenes/dice/dice_ten.gd scenes/dice/dice_ten.tscn
git commit -m "feat: add dice_ten.gd script for consistency with dice_six and dice_eight"
```

---

### Task 10: Create autoload/config_loader.gd

**Files:**
- Create: `autoload/config_loader.gd`

- [ ] **Step 1: Create config_loader.gd**

Create `autoload/config_loader.gd` with this content:

```gdscript
extends Node

# Stub for the JSON-driven configuration loading system.
# Future: load board configs from data/boards/ and dice configs from data/dice/


func get_board(board_id: String) -> Dictionary:
	return {}


func get_dice(dice_id: String) -> Dictionary:
	return {}
```

- [ ] **Step 2: Commit**

```bash
git add autoload/config_loader.gd
git commit -m "feat: add ConfigLoader autoload stub"
```

---

### Task 11: Register ConfigLoader in project.godot

**Files:**
- Modify: `project.godot`

- [ ] **Step 1: Add autoload section to project.godot**

In `project.godot`, add the following block after the `[rendering]` section:

```ini
[autoload]

ConfigLoader="*res://autoload/config_loader.gd"
```

- [ ] **Step 2: Verify**

```bash
grep -A2 "\[autoload\]" project.godot
```

Expected output:
```
[autoload]

ConfigLoader="*res://autoload/config_loader.gd"
```

- [ ] **Step 3: Commit**

```bash
git add project.godot
git commit -m "chore: register ConfigLoader as AutoLoad singleton"
```

---

### Task 12: Create data JSON files

**Files:**
- Create: `data/boards/standard.json`
- Create: `data/dice/d6_basic.json`
- Create: `data/dice/d8_basic.json`
- Create: `data/dice/d10_basic.json`

- [ ] **Step 1: Create standard.json**

Create `data/boards/standard.json` encoding the current hardcoded board from `scenes/game/main.tscn` (column/row indices derived from the scene's Vector2 positions at 80px spacing, starting at x=160):

```json
{
  "id": "standard",
  "grid": { "columns": 5, "rows": 4 },
  "dice": [
    { "dice_id": "d6_basic",  "position": [0, 0] },
    { "dice_id": "d8_basic",  "position": [0, 1] },
    { "dice_id": "d8_basic",  "position": [0, 2] },
    { "dice_id": "d8_basic",  "position": [0, 3] },
    { "dice_id": "d6_basic",  "position": [1, 0] },
    { "dice_id": "d10_basic", "position": [1, 1] },
    { "dice_id": "d10_basic", "position": [1, 2] },
    { "dice_id": "d8_basic",  "position": [1, 3] },
    { "dice_id": "d6_basic",  "position": [2, 0] },
    { "dice_id": "d6_basic",  "position": [2, 1] },
    { "dice_id": "d6_basic",  "position": [2, 2] },
    { "dice_id": "d6_basic",  "position": [2, 3] },
    { "dice_id": "d6_basic",  "position": [3, 0] },
    { "dice_id": "d10_basic", "position": [3, 1] },
    { "dice_id": "d10_basic", "position": [3, 2] },
    { "dice_id": "d8_basic",  "position": [3, 3] },
    { "dice_id": "d6_basic",  "position": [4, 0] },
    { "dice_id": "d8_basic",  "position": [4, 1] },
    { "dice_id": "d8_basic",  "position": [4, 2] },
    { "dice_id": "d8_basic",  "position": [4, 3] }
  ]
}
```

- [ ] **Step 2: Create d6_basic.json**

Create `data/dice/d6_basic.json`:

```json
{
  "id": "d6_basic",
  "sides": 6,
  "sprite_folder": "d6-white",
  "abilities": []
}
```

- [ ] **Step 3: Create d8_basic.json**

Create `data/dice/d8_basic.json`:

```json
{
  "id": "d8_basic",
  "sides": 8,
  "sprite_folder": "d8-blue",
  "abilities": []
}
```

- [ ] **Step 4: Create d10_basic.json**

Create `data/dice/d10_basic.json`:

```json
{
  "id": "d10_basic",
  "sides": 10,
  "sprite_folder": "d10-gr",
  "abilities": []
}
```

- [ ] **Step 5: Commit**

```bash
git add data/
git commit -m "feat: add initial board and dice config stubs"
```

---

### Task 13: Fix code quality issues

**Files:**
- Modify: `scenes/game/board_map.gd`
- Modify: `scenes/ui/hud.gd`
- Modify: `scenes/ui/hud.tscn`

- [ ] **Step 1: Rename Tile_State enum to TileState in board_map.gd**

In `scenes/game/board_map.gd`, make these changes:

Change the enum declaration:
```gdscript
enum Tile_State {
	ACTIVE,
	INACTIVE,
	SELECTED
}
var tile_status: Array[Tile_State]
```
To:
```gdscript
enum TileState {
	ACTIVE,
	INACTIVE,
	SELECTED
}
var tile_status: Array[TileState]
```

In `update_tile_sprites()`, change:
```gdscript
		match tile_status[status_index]:
			Tile_State.ACTIVE:
				tilemap.set_cell(tile, 0, active_sprite)
			Tile_State.INACTIVE:
				tilemap.set_cell(tile, 0, inactive_sprite)
			Tile_State.SELECTED:
				tilemap.set_cell(tile, 0, selected_sprite)
```
To:
```gdscript
		match tile_status[status_index]:
			TileState.ACTIVE:
				tilemap.set_cell(tile, 0, active_sprite)
			TileState.INACTIVE:
				tilemap.set_cell(tile, 0, inactive_sprite)
			TileState.SELECTED:
				tilemap.set_cell(tile, 0, selected_sprite)
```

In `toggle_selected_tiles()`, change:
```gdscript
	match tile_status[status_index]:
		Tile_State.ACTIVE:
			tile_status[status_index] = Tile_State.SELECTED
			emit_signal("tile_clicked", status_index, true)
		Tile_State.SELECTED:
			tile_status[status_index] = Tile_State.ACTIVE
			emit_signal("tile_clicked", status_index, false)
```
To:
```gdscript
	match tile_status[status_index]:
		TileState.ACTIVE:
			tile_status[status_index] = TileState.SELECTED
			emit_signal("tile_clicked", status_index, true)
		TileState.SELECTED:
			tile_status[status_index] = TileState.ACTIVE
			emit_signal("tile_clicked", status_index, false)
```

In `update_tiles_status()`, change:
```gdscript
	for i in range(tile_status.size()):
		if tile_status[i] == Tile_State.SELECTED:
			tile_status[i] = Tile_State.INACTIVE
```
To:
```gdscript
	for i in range(tile_status.size()):
		if tile_status[i] == TileState.SELECTED:
			tile_status[i] = TileState.INACTIVE
```

In `is_tile_selected()`, change:
```gdscript
	for tile in tile_status:
		if tile == Tile_State.SELECTED:
			return true
```
To:
```gdscript
	for tile in tile_status:
		if tile == TileState.SELECTED:
			return true
```

- [ ] **Step 2: Remove dead pass in board_map.gd**

In `scenes/game/board_map.gd`, change:
```gdscript
func _process(delta):
	update_tile_sprites()
	pass
```
To:
```gdscript
func _process(delta):
	update_tile_sprites()
```

- [ ] **Step 3: Remove dead pass in hud.gd**

In `scenes/ui/hud.gd`, change:
```gdscript
func _ready():
	roll_button.disabled = true
	pass # Replace with function body.
```
To:
```gdscript
func _ready():
	roll_button.disabled = true
```

- [ ] **Step 4: Clear "Test Message" from hud.tscn**

In `scenes/ui/hud.tscn`, find and change:
```
text = "Test Message"
```
To:
```
text = ""
```

- [ ] **Step 5: Verify TileState rename is complete**

```bash
grep -rn "Tile_State" . --include="*.gd" --exclude-dir=".godot"
```

Expected: No output.

- [ ] **Step 6: Commit**

```bash
git add scenes/game/board_map.gd scenes/ui/hud.gd scenes/ui/hud.tscn
git commit -m "fix: rename Tile_State to TileState, remove dead pass statements, clear test label"
```

---

### Task 14: Final verification

- [ ] **Step 1: Confirm expected file structure**

```bash
find . \( -name "*.gd" -o -name "*.tscn" \) -not -path "./.godot/*" | sort
```

Expected (exact list):
```
./autoload/config_loader.gd
./scenes/dice/base_dice.gd
./scenes/dice/base_dice.tscn
./scenes/dice/dice_eight.gd
./scenes/dice/dice_eight.tscn
./scenes/dice/dice_six.gd
./scenes/dice/dice_six.tscn
./scenes/dice/dice_ten.gd
./scenes/dice/dice_ten.tscn
./scenes/game/board_map.gd
./scenes/game/board_map.tscn
./scenes/game/dice_container.gd
./scenes/game/main.gd
./scenes/game/main.tscn
./scenes/ui/game_over_menu.gd
./scenes/ui/game_over_menu.tscn
./scenes/ui/hud.gd
./scenes/ui/hud.tscn
./scenes/ui/main_menu.gd
./scenes/ui/main_menu.tscn
```

- [ ] **Step 2: Confirm no stale paths remain**

```bash
grep -rn "res://sprites/" . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "\"res://board_map" . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "res://scenes/base_dice" . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "res://scenes/dice_" . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "res://scenes/main\." . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "res://scenes/hud\." . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "res://scenes/main_menu\." . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "res://scenes/game_over_menu\." . --include="*.gd" --include="*.tscn" --exclude-dir=".godot"
grep -rn "Tile_State" . --include="*.gd" --exclude-dir=".godot"
grep -rn "Test Message" . --include="*.tscn" --exclude-dir=".godot"
```

Expected: All greps return no output.

- [ ] **Step 3: Confirm data and asset directories**

```bash
ls data/boards/ data/dice/ assets/sprites/
```

Expected:
```
data/boards/:
standard.json

data/dice/:
d6_basic.json  d8_basic.json  d10_basic.json

assets/sprites/:
basic-diced-tileset.png  d6-white  d8-blue  d10-gr  d12-red
```

- [ ] **Step 4: Open project in Godot and verify**

Open the project in the Godot 4 editor. Confirm:
1. No errors or missing resource warnings in the FileSystem dock
2. No script errors in the Output panel on launch
3. Press F5: main menu loads, Start button transitions to gameplay, dice are clickable, Roll button functions, game over screen is reachable
4. `ConfigLoader` appears in Project → Project Settings → AutoLoad

If Godot shows a missing resource error, the error message will name the file and the broken path. Run the relevant `sed` command from Task 8 against that specific file and re-commit.
