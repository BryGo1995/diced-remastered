extends Control


@onready var play_button: Button = $VBoxContainer/StartButton


func _ready():
	play_button.pressed.connect(_on_start_button_pressed)


func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
