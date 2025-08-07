extends Node2D

@export var speedReduction = 50.0
@export var duration = 5.0
var duration_time_elapsed = 0.0
var shadow

func _ready() -> void:
	changeSpeed(get_parent().speed* (speedReduction/100))
	shadow = get_parent().get_node("Slime/GroundShadow")
	shadow.modulate = Color("ab790396")

func _process(delta: float) -> void:
	duration_time_elapsed += delta
	if get_parent().has_method("take_damage"):
		if duration_time_elapsed > duration:
			changeSpeed(get_parent().speed * (100/speedReduction))
			shadow.modulate = Color("00000096")
			queue_free()

func changeSpeed(speed: float):
	get_parent().speed = speed
