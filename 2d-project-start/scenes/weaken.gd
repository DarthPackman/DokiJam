extends Node2D

@export var dmgDecrease = 25.0
@export var duration = 5.0
var duration_time_elapsed = 0.0
var shadow
@onready var spreadAoe = $Area2D

func _ready() -> void:
	shadow = get_parent().get_node("Slime/GroundShadow")
	shadow.modulate = Color("ff61ce96")
	changeDamage(1.0 - (dmgDecrease / 100))

func _process(delta: float) -> void:
	duration_time_elapsed += delta
	if get_parent().has_method("take_damage"):
		if duration_time_elapsed > duration:
			changeDamage(1.0)
			shadow.modulate = Color("00000096")
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
