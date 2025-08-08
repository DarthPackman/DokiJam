extends Node2D

@export var speedReduction = 50.0
@export var duration = 5.0
var duration_time_elapsed = 0.0
var character
@onready var aoeCollider = $StaticBody2D/CollisionShape2D

func _ready() -> void:
	if get_parent().get_child(0).has_node("AnimatedSprite2D"):
		character = get_parent().get_child(0).get_node("AnimatedSprite2D")
		character.modulate = Color("c8bf53")
	changeSpeed(get_parent().speed * (1 - (speedReduction/100)))

func _process(delta: float) -> void:
	duration_time_elapsed += delta
	if get_parent().has_method("take_damage"):
		if duration_time_elapsed > duration:
			changeSpeed(get_parent().speed * (1+(speedReduction/75)))
			if character:
				character.modulate = Color("9792ff")
			queue_free()

func changeSpeed(speed: float):
	get_parent().speed = speed
	print(speed)
	
func detonate_effect():
	var stunLength = duration * (speedReduction/100)
	StatusEffects.applyStun(get_parent(), stunLength)

func enhance_effect():
	changeSpeed(get_parent().speed * (speedReduction/100))
