extends Node2D

@onready var board_map: Node2D = $BoardMap
@onready var dice_container: Node2D = $DiceContainer
@onready var hud: Control = $UI/HUD


# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_rect: Rect2 = get_viewport_rect()
	board_map.position.x = viewport_rect.size.x/2 - (board_map.map_size_pixels.x/2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_roll_button_status()
	pass


func update_roll_button_status():
	var button_enabled = board_map.is_tile_selected()
	if button_enabled:
		hud.enable_roll_button()
	else:
		hud.disable_roll_button()


func roll_all_dice():
	dice_container.roll_all_dice()
	board_map.update_tiles_status()


func calculate_selected_score():
	pass
