extends Node2D

var tile_scene: PackedScene = preload("res://scenes/tile.tscn")

@export_category("Board Properties")
@export var columns: int
@export var rows: int
@export var board_color = Color(0.0, 0.3, 0.2)

@export_category("Tile Properties")
@export var tile_size := Vector2(70, 70)
@export var tile_spacing := Vector2(20, 4)
@export var tile_color = Color(0.3, 0.0, 0.3)

var board := Rect2()

var tile_positions := PackedVector2Array()
var tile_centers := PackedVector2Array()
var tiles: Array[Node2D] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	set_board_dimensions()
	
	calculate_tile_positions()
	calculate_tile_centers()
	create_tiles()
	
	set_child_node_positions()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _draw():
	# Draw the board
	draw_rect(board, board_color)


# Calculate the board dimensions based on the size and spacing
func set_board_dimensions():
	var board_dimensions = Vector2()
	board_dimensions.x = columns * tile_size.x + ((columns + 1) * tile_spacing.x)
	board_dimensions.y = rows * tile_size.y + ((rows + 1) * tile_spacing.y)
	board.size = board_dimensions
	print(board)


# Based on the number of child nodes, we want to make an informed decision on how many columns/rows
# there should be.
func calculate_tile_positions():
	var pos: Vector2
	for i in range(rows*columns):
		pos.x = tile_spacing.x + (i % columns)*((board.size.x - tile_spacing.x)/columns)
		pos.y = tile_spacing.y + (i / columns)*((board.size.y - tile_spacing.y)/rows)
		tile_positions.push_back(pos)
		
		
func calculate_tile_centers():
	var pos: Vector2
	for t in tile_positions:
		pos = t + tile_size/2
		tile_centers.push_back(pos)
		
		
func create_tiles():
	for t in tile_positions:
		var tile_instance = tile_scene.instantiate()
		tile_instance.tile.position = t
		tiles.push_back(tile_instance)
		add_child(tile_instance)
		
	
func set_child_node_positions():
	var index = 0
	for child in get_children():
		assert(index < rows*columns)
		if child.is_in_group("Dice"):
			child.position = tile_centers[index]
			index += 1
