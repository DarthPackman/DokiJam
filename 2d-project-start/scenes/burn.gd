extends Node2D

@export var damage = 1.0
@export var interval = 1.0
@export var duration = 5.0
var time_elapsed = 0.0
var duration_time_elapsed = 0.0
var character
@onready var spreadAoe = $Area2D

func _ready() -> void:
	if get_parent().get_child(0).has_node("AnimatedSprite2D"):
		character = get_parent().get_child(0).get_node("AnimatedSprite2D")
		character.modulate = Color("ff0000")

func _process(delta: float) -> void:
	time_elapsed += delta
	duration_time_elapsed += delta
	if time_elapsed >= interval:
		time_elapsed -= interval
		if get_parent().has_method("take_damage"):
			var damageType = DamageNumbers.DamageTypes.BURN
			get_parent().take_damage(damage, damageType)
		if duration_time_elapsed > duration:
			if character:
				character.modulate = Color("9792ff")
			queue_free()

func spread_effect():
	var overlapping_mobs = spreadAoe.get_overlapping_bodies()
	for mob in overlapping_mobs:
		if mob.has_method("take_damage"):
			var burnDOT = self.duplicate()
			mob.add_child(burnDOT)
			
func detonate_effect():
	get_parent().takeDamage(damage * duration/interval)
