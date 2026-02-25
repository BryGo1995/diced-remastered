extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_rect: Rect2 = get_viewport_rect()
	$BoardMap.position.x = viewport_rect.size.x/2 - ($BoardMap.map_size_pixels.x/2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_roll_button_status()
	pass


func update_roll_button_status():
	var button_enabled = $BoardMap.is_tile_selected()
	if button_enabled:
		$UI/HUD.enable_roll_button()
	else:
		$UI/HUD.disable_roll_button()


func roll_all_dice():
	$DiceContainer.roll_all_dice()
	$BoardMap.update_tiles_status()


func calculate_selected_score():
	pass
