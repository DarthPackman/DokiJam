extends Node2D

@export var speedReduction = 100.0
@export var duration = 1.0
var duration_time_elapsed = 0.0
var character
@onready var aoeCollider = $StaticBody2D/CollisionShape2D
var previousDamage = 0

func _ready() -> void:
	changeSpeed(get_parent().speed * (speedReduction/100))
	previousDamage = get_parent().damageDealt
	get_parent().damageDealt = 0
	if get_parent().get_child(0).has_node("AnimatedSprite2D"):
		character = get_parent().get_child(0).get_node("AnimatedSprite2D")
		character.modulate = Color("ffffff")

func _process(delta: float) -> void:
	duration_time_elapsed += delta
	if get_parent().has_method("take_damage"):
		if duration_time_elapsed > duration:
			changeSpeed(get_parent().speed * (100/speedReduction))
			get_parent().damageDealt = previousDamage
			if character:
				character.modulate = Color("9792ff")
			queue_free()

func changeSpeed(speed: float):
	get_parent().speed = speed
