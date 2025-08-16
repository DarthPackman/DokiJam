extends Area2D

@export var w_name: String = "Egg's Rotten"
@export var weapon_icon: Texture2D
@export var triggerTime = 0.5
var trigger_time_elapsed = 0.0
@export var duration = 1.0
var duration_time_elapsed = 0.0
@export var damage = 2.5
@export var statusEffectDisabled = false
@onready var areaOfEffect = %AOE
@onready var fx = %FX
var currentLvl = 1

func _ready() -> void:
	areaOfEffect.play("trigger")
	fx.play("trigger")
	
func _physics_process(delta: float) -> void:
	duration_time_elapsed += delta
	trigger_time_elapsed += delta
	if not fx.is_playing():
		fx.play("duration")
		areaOfEffect.play("duration")
	
	if  trigger_time_elapsed >= triggerTime:
		var hit_mobs = get_overlapping_bodies()
		for enemy in hit_mobs:
			if enemy.has_method("take_damage"):
				var damageType = DamageNumbers.DamageTypes.NORMAL
				enemy.take_damage(damage, damageType)
				if not statusEffectDisabled:
					StatusEffects.applyPoison(enemy)
		trigger_time_elapsed = 0.0

func level_up():
	currentLvl += 1
	triggerTime = triggerTime * 0.9
	damage = damage * 1.1
	if currentLvl % 5 == 0:
		self.scale = self.scale * 1.25
