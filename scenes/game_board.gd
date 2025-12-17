extends Node2D

@export var columns = 0
@export var rows = 0
var node_positions := PackedVector2Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_dimensions: Vector2 = get_viewport().size
	
	var children: Array = get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_dimensions(width, height):
	pass

# Based on the number of child nodes, we want to make an informed decision on how many columns/rows
# there should be.
func calculate_node_positions():
	var pos: Vector2
	for i in range(get_child_count()):
		
		
	node_positions.push_back()
	pass
