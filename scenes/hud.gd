extends Control

signal roll_dice

@onready var roll_button: Button = $VBoxContainer/Panel/MarginContainer/HBoxContainer/RollButton

# Called when the node enters the scene tree for the first time.
func _ready():
	roll_button.disabled = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_roll_button_pressed():
	roll_dice.emit()


func enable_roll_button():
	roll_button.disabled = false
	
func disable_roll_button():
	roll_button.disabled = true
