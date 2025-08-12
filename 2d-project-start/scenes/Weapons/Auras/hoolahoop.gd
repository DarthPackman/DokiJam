extends Area2D

@export var triggerTime = 0.5
var trigger_time_elapsed = 0.0
var duration = 5.0
var duration_time_elapsed = 0.0
var damage = 2.5
@export var rotationSpeed = 0.05
@export var statusEffectDisabled = false
@onready var areaOfEffect = %AOE
@onready var hoop = %Hoop
@onready var pivot = $"."

func _ready() -> void:
	areaOfEffect.play("trigger")
	
func _physics_process(delta: float) -> void:
	hoop.rotation += rotationSpeed
	pivot.rotation += rotationSpeed
	duration_time_elapsed += delta
	trigger_time_elapsed += delta
	if not areaOfEffect.is_playing():
		areaOfEffect.play("duration")
	
	if  trigger_time_elapsed >= triggerTime:
		var hit_mobs = hoop.get_overlapping_bodies()
		for enemy in hit_mobs:
			if enemy.has_method("take_damage"):
				var damageType = DamageNumbers.DamageTypes.NORMAL
				enemy.take_damage(damage, damageType)
				if not statusEffectDisabled:
					StatusEffects.applyWeaken(enemy)
		trigger_time_elapsed = 0.0

func level_up():
	pass
