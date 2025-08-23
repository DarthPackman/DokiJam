extends Area2D

@onready var attackSpeedTimer = $Timer
@export var w_name: String = "Chonk's Boots"
@export var weapon_icon: Texture2D
@export var attackSpeed = 1.0
@export var statusEffectDisabled = false
@export var duration = 1.5
var zoneDurMult = 1.0
var zoneDmgMult = 1.0
var zoneIntMult = 1.0
var zoneScaMult = 1.0
var currentLvl = 1.0

func _ready() -> void:
	attackSpeedTimer.wait_time = attackSpeed

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0.0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func shoot():
	const ZONE = preload("res://scenes/Weapons/Zones/smashedground.tscn")
	var new_zone = ZONE.instantiate()
	new_zone.global_position = %LandingSpot.global_position
	new_zone.global_rotation = %LandingSpot.global_rotation
	new_zone.duration *= zoneDurMult
	new_zone.damage *= zoneDmgMult
	new_zone.interval *= zoneIntMult
	new_zone.scale *= zoneScaMult
	new_zone.disabled = statusEffectDisabled
	get_tree().root.add_child(new_zone)

func _on_timer_timeout() -> void:
	shoot()

func level_up():
	currentLvl += 1.0
	
	zoneDmgMult *= 1.1
	zoneIntMult *= 0.9
	attackSpeed *= 0.9
	attackSpeedTimer.wait_time = attackSpeed
	
	if currentLvl % 5.0 == 0.0:
		zoneScaMult *= 1.25
		zoneDurMult *= 1.25
