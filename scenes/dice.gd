extends CharacterBody2D

@export var value = 1
var rng = RandomNumberGenerator.new()

func _ready():
	randomize_value()
	
func _process(delta):
	$AnimatedSprite2D.animation = "side" + str(value)
	pass

func _physics_process(delta):
	move_and_slide()

func randomize_value():
	value = rng.randi_range(1, 8)
	print(value)
	pass
