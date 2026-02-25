extends Node2D

var selected_dice: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_selected_dice(index, state):
	if state:
		selected_dice.append(get_child(index))
	else:
		selected_dice.erase(get_child(index))
	print(selected_dice)


func roll_all_dice():
	for dice in selected_dice:
		dice.randomize_value()


func roll_active_dice():
	pass
