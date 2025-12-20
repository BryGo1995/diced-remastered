extends Node2D

var tile_size := Vector2(68, 68)
var tile_color := Color(0.3, 0.0, 0.3)
var tile := Rect2(position, tile_size)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw():
	draw_rect(tile, tile_color)
