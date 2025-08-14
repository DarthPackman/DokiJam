extends Area2D

@onready var attackSpeedTimer = $Timer
@export var w_name: String = "Long's Dragoon Drop"
@export var weapon_icon: Texture2D
@export var attackSpeed = 0.75
@export var statusEffectDisabled = false
@export var duration = 1.0
var zoneDurMult = 1.0
var zoneDmgMult = 1.0
var zoneIntMult = 1.0
var zoneScaMult = 1.0
var currentLvl = 1

func _ready() -> void:
	attackSpeedTimer.wait_time = attackSpeed

func _physics_process(delta: float) -> void:
	var random_x = randi() % int(get_viewport_rect().size.x)
	var random_y = randi() % int(get_viewport_rect().size.y)
	var random_position = Vector2(random_x, random_y)
	look_at(random_position)

func shoot():
	const ZONE = preload("res://scenes/Weapons/Zones/dragoondrop.tscn")
	var new_zone = ZONE.instantiate()
	new_zone.global_position = %LandingSpot.global_position
	new_zone.disabled = statusEffectDisabled
	new_zone.duration *= zoneDurMult
	new_zone.damage *= zoneDmgMult
	new_zone.interval *= zoneIntMult
	new_zone.scale *= zoneScaMult
	get_tree().root.add_child(new_zone)

func _on_timer_timeout() -> void:
	shoot()

func level_up():
	currentLvl += 1
	
	zoneDmgMult *= 1.1
	zoneIntMult *= 0.9
	attackSpeed *= 0.9
	attackSpeedTimer.wait_time = attackSpeed
	
	if currentLvl % 5 == 0:
		zoneScaMult *= 1.25
		zoneDurMult *= 1.25
