extends Node2D

@export var damage = 2.0
@export var interval = 2.0
@export var duration = 10.0
var time_elapsed = 0.0
var duration_time_elapsed = 0.0
var shadow

func _ready() -> void:
	shadow = get_parent().get_node("Slime/GroundShadow")
	shadow.modulate = Color("8401c196")

func _process(delta: float) -> void:
	time_elapsed += delta
	duration_time_elapsed += delta
	if time_elapsed >= interval:
		time_elapsed -= interval
		if get_parent().has_method("take_damage"):
			var damageType = DamageNumbers.DamageTypes.POISON
			get_parent().take_damage(damage, damageType)
		if duration_time_elapsed > duration:
			shadow.modulate = Color("00000096")
			queue_free()
