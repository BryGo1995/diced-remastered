extends Control

signal roll_dice

@onready var roll_button: Button = $VBoxContainer/Panel/MarginContainer/HBoxContainer/RollButton
@onready var score: Label = $VBoxContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/TotalScoreValue
@onready var selected_score: Label = $VBoxContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/SelectedScoreValue

# Called when the node enters the scene tree for the first time.
func _ready():
	roll_button.disabled = true


func _on_roll_button_pressed():
	roll_dice.emit()


func enable_roll_button():
	roll_button.disabled = false


func disable_roll_button():
	roll_button.disabled = true


func set_score(s):
	score.text = str(s)


func set_selected_score(s):
	selected_score.text = str(s)
