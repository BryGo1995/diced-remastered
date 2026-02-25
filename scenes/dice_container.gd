extends Node2D

var selected_dice: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func roll_all_dice():
	for dice in get_children():
		dice.randomize_value()


func roll_active_dice():
	pass
