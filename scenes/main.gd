extends Node2D

@onready var board_map: Node2D = $BoardMap
@onready var dice_container: Node2D = $DiceContainer
@onready var hud: Control = $UI/HUD


func _ready():
	# Connecting signals to callbacks
	board_map.tile_clicked.connect(_on_tile_clicked)
	hud.roll_dice.connect(_on_roll_button_pressed)

	var viewport_rect: Rect2 = get_viewport_rect()
	board_map.position.x = viewport_rect.size.x/2 - (board_map.map_size_pixels.x/2)


func _process(delta):
	update_roll_button_status()
	pass


func _on_tile_clicked(coords, state):
	update_selected_dice(coords, state)


func _on_roll_button_pressed():
	dice_container.calculate_roll_score()
	dice_container.roll_active_dice()
	board_map.update_tiles_status()


func update_roll_button_status():
	var button_enabled = board_map.is_tile_selected()
	if button_enabled:
		hud.enable_roll_button()
	else:
		hud.disable_roll_button()


func update_selected_dice(coords, state):
	dice_container.update_selected_dice(coords, state)


func calculate_selected_score():
	pass
