extends Area2D

@export var w_name: String = "Long's Hoola"
@export var weapon_icon: Texture2D
@export var triggerTime = 0.49
var trigger_time_elapsed = 0.0
@export var duration = 1.5
var damage = 2.5
@export var rotationSpeed = 0.05
@export var statusEffectDisabled = false
@onready var areaOfEffect = %AOE
@onready var hoop = %Hoop
@onready var pivot = $"."
var currentLvl = 1.0

func _ready() -> void:
	areaOfEffect.play("trigger")
	
func _physics_process(delta: float) -> void:
	trigger_time_elapsed += delta
	if not areaOfEffect.is_playing():
		areaOfEffect.play("duration")
	
	if areaOfEffect.get_animation() == "duration":
		hoop.rotation += rotationSpeed
		pivot.rotation += rotationSpeed
	
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
	currentLvl += 1.0
	triggerTime = triggerTime * 0.9
	damage = damage * 1.1
	if currentLvl % 5.0 == 0.0:
		self.scale = self.scale * 1.25
