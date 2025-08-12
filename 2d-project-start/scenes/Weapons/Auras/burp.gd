extends Area2D

@export var triggerTime = 0.5
var trigger_time_elapsed = 0.0
var duration = 1.0
var duration_time_elapsed = 0.0
var damage = 2.5
@export var statusEffectDisabled = false
@onready var areaOfEffect = %AOE
@onready var burpCollider = %BurpC2D
	
func _physics_process(delta: float) -> void:
	duration_time_elapsed += delta
	trigger_time_elapsed += delta
	
	if areaOfEffect.frame == 0:
		burpCollider.shape.radius = 5
	elif areaOfEffect.frame == 1:
		burpCollider.shape.radius = 6.75
	elif areaOfEffect.frame == 2:
		burpCollider.shape.radius = 8.75
	elif areaOfEffect.frame == 3:
		burpCollider.shape.radius = 11.0
	elif areaOfEffect.frame == 4:
		burpCollider.shape.radius = 13
	elif areaOfEffect.frame == 5:
		burpCollider.shape.radius = 16
	
	if  trigger_time_elapsed >= triggerTime:
		var hit_mobs = get_overlapping_bodies()
		for enemy in hit_mobs:
			if enemy.has_method("take_damage"):
				var damageType = DamageNumbers.DamageTypes.NORMAL
				enemy.take_damage(damage, damageType)
				if not statusEffectDisabled:
					StatusEffects.applySlow(enemy)
		trigger_time_elapsed = 0.0
