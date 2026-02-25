extends Node2D

var selected_dice: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_selected_dice(index, state):
	if state:
		selected_dice.append(get_child(index))
	else:
		selected_dice.erase(get_child(index))


func roll_active_dice():
	for dice in get_children():
		if dice.state == dice.DiceState.ACTIVE:
			dice.randomize_value()


func calculate_roll_score():
	var cumulative_score = 0
	for dice in selected_dice:
		cumulative_score += dice.calculate_score()
	update_dice_state()


func update_dice_state():
	for dice in selected_dice:
		dice.state = dice.DiceState.INACTIVE
	selected_dice.clear()
