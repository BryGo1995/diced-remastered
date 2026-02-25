extends Node2D

@export var textures: Array[Texture2D] = []

var number_of_sides: int = 0
var value: int = 0
var rng = RandomNumberGenerator.new()

enum DiceState {
	ACTIVE,
	INACTIVE,
}
var state: DiceState = DiceState.ACTIVE


func _ready():
	# Calculate the number of sides based on the textures provided
	# Provide a blank dice for the 0 texture to ensure proper side calculation
	number_of_sides = textures.size()-1
	
	var new_frames = SpriteFrames.new()
	for index in range(textures.size()):
		var animation_name = "side" + str(index)
		new_frames.add_animation(animation_name)
		new_frames.add_frame(animation_name, textures[index])
	
	$AnimatedSprite2D.sprite_frames = new_frames
	
	randomize_value()


func _process(delta):
	$AnimatedSprite2D.animation = "side" + str(value)


func calculate_score():
	return number_of_sides - value


func randomize_value():
	value = rng.randi_range(1, number_of_sides)
