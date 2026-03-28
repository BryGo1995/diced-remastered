extends Node2D

signal tile_clicked(local_tile_coords: int, tile_state: bool)

@onready var tilemap: TileMapLayer = $TileMapLayer
var map_size_tiles: Vector2i
var map_size_pixels: Vector2
var used_tiles: Array[Vector2i]

enum TileState {
	ACTIVE,
	INACTIVE,
	SELECTED
}
var tile_status: Array[TileState]

var active_sprite := Vector2i(15, 15)
var inactive_sprite := Vector2i(5, 15)
var selected_sprite := Vector2i(25, 15)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Calculate map size in tiles
	var used_rect_coords: Rect2i = tilemap.get_used_rect()
	map_size_tiles = used_rect_coords.size
	
	# Calculate map size in pixels
	var map_origin: Vector2 = tilemap.map_to_local(used_rect_coords.position)
	var map_end: Vector2 = tilemap.map_to_local(used_rect_coords.position + used_rect_coords.size)
	map_size_pixels = map_end - map_origin
	
	# Create an array of used tiles and their x, y position
	for tile in tilemap.get_used_cells():
		used_tiles.append(tile)
	
	# Initialize the tile status array
	tile_status.resize(map_size_tiles.x * map_size_tiles.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_tile_sprites()


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var local_mouse = get_local_mouse_position()
			var tile_coords = tilemap.local_to_map(local_mouse)
			toggle_selected_tiles(tile_coords)


func update_tile_sprites():
	for tile in used_tiles:
		var status_index = tile.x * 4 + tile.y
		match tile_status[status_index]:
			TileState.ACTIVE:
				tilemap.set_cell(tile, 0, active_sprite)
			TileState.INACTIVE:
				tilemap.set_cell(tile, 0, inactive_sprite)
			TileState.SELECTED:
				tilemap.set_cell(tile, 0, selected_sprite)


func toggle_selected_tiles(position):
	if position.x < 0 or position.x >= map_size_tiles.x:
		return
	if position.y < 0 or position.y >= map_size_tiles.y:
		return
		
	var status_index = position.x * 4 + position.y
	match tile_status[status_index]:
		TileState.ACTIVE:
			tile_status[status_index] = TileState.SELECTED
			emit_signal("tile_clicked", status_index, true)
		TileState.SELECTED:
			tile_status[status_index] = TileState.ACTIVE
			emit_signal("tile_clicked", status_index, false)


func update_tiles_status():
	for i in range(tile_status.size()):
		if tile_status[i] == TileState.SELECTED:
			tile_status[i] = TileState.INACTIVE


# Check if any tiles are currently selected
func is_tile_selected():
	for tile in tile_status:
		if tile == TileState.SELECTED:
			return true
	return false
