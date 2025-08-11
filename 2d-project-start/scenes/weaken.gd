extends Node2D

@export var dmgDecrease = 25.0
@export var duration = 5.0
var duration_time_elapsed = 0.0
var character
@onready var spreadAoe = $Area2D

func _ready() -> void:
	if get_parent().get_child(0).has_node("AnimatedSprite2D"):
		character = get_parent().get_child(0).get_node("AnimatedSprite2D")
		character.modulate = Color("ed8cac")
	changeDamage(1.0 - (dmgDecrease / 100))

func _process(delta: float) -> void:
	duration_time_elapsed += delta
	if get_parent().has_method("take_damage"):
		if duration_time_elapsed > duration:
			changeDamage(1.0)
			if character:
				character.modulate = Color("9792ff")
			queue_free()
			
func changeDamage(dmgMult):
	get_parent().dmgDealtMult = dmgMult
	
func spread_effect():
	var overlapping_mobs = spreadAoe.get_overlapping_bodies()
	for mob in overlapping_mobs:
		if mob.has_method("take_damage"):
			var weakDebuff = self.duplicate()
			mob.add_child(weakDebuff)

func enhance_effect():
	changeDamage(1.0 + (dmgDecrease / 100))
