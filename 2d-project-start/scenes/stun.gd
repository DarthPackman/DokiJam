extends Node2D

@export var speedReduction = 100.0
@export var duration = 1.0
var duration_time_elapsed = 0.0
var shadow
@onready var aoeCollider = $StaticBody2D/CollisionShape2D
var previousDamage = 0

func _ready() -> void:
	changeSpeed(get_parent().speed * (speedReduction/100))
	previousDamage = get_parent().damageDealt
	get_parent().damageDealt = 0
	shadow = get_parent().get_node("Slime/GroundShadow")
	shadow.modulate = Color("000000")

func _process(delta: float) -> void:
	duration_time_elapsed += delta
	if get_parent().has_method("take_damage"):
		if duration_time_elapsed > duration:
			changeSpeed(get_parent().speed * (100/speedReduction))
			get_parent().damageDealt = previousDamage
			shadow.modulate = Color("00000096")
			queue_free()

func changeSpeed(speed: float):
	get_parent().speed = speed
