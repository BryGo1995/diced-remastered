extends Control


@onready var play_again_button: Button = $VBoxContainer/PlayAgainButton
@onready var main_menu_button: Button = $VBoxContainer/MainMenuButton


# Called when the node enters the scene tree for the first time.
func _ready():
	play_again_button.pressed.connect(_on_play_again_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_again_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game/main.tscn")


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
