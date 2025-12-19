extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_rect: Rect2 = get_viewport_rect()
	$GameBoard.position = viewport_rect.size / 2 - $GameBoard.board.size/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func roll_all_dice():
	var dice_group = get_tree().get_nodes_in_group("Dice")
	for d in dice_group:
		d.randomize_value() 
