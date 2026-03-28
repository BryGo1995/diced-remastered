extends Node2D

@onready var board_map: Node2D = $BoardMap
@onready var dice_container: Node2D = $DiceContainer
@onready var hud: Control = $UI/HUD

var score: int = 0
var selected_score: int = 0

func _ready():
	# Connecting signals to callbacks
	board_map.tile_clicked.connect(_on_tile_clicked)
	hud.roll_dice.connect(_on_roll_button_pressed)

	var viewport_rect: Rect2 = get_viewport_rect()
	board_map.position.x = viewport_rect.size.x/2 - (board_map.map_size_pixels.x/2)


func _process(delta):
	update_roll_button_status()
	if not board_map.is_game_active():
		get_tree().change_scene_to_file("res://scenes/ui/game_over_menu.tscn")


func _on_tile_clicked(coords, state):
	update_selected_dice(coords, state)
	update_selected_score_hud()


func _on_roll_button_pressed():
	score += selected_score
	update_score_hud()
	dice_container.update_dice_state()
	dice_container.roll_active_dice()
	update_selected_score_hud()
	board_map.update_tiles_status()


func update_roll_button_status():
	var button_enabled = board_map.is_tile_selected()
	if button_enabled:
		hud.enable_roll_button()
	else:
		hud.disable_roll_button()


func update_selected_dice(coords, state):
	dice_container.update_selected_dice(coords, state)


func update_score_hud():
	hud.set_score(score)


func update_selected_score_hud():
	selected_score = dice_container.calculate_selected_score()
	hud.set_selected_score(selected_score)
