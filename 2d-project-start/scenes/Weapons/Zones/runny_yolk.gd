extends Area2D

@onready var attackSpeedTimer = $Timer
@export var w_name: String = "Egg's Runny Yolk"
@export var weapon_icon: Texture2D
@export var attackSpeed = 0.25
@export var statusEffectDisabled = false
@export var duration = 1.0
var zoneDurMult = 1.0
var zoneDmgMult = 1.0
var zoneIntMult = 1.0
var zoneScaMult = 1.0
var currentlvl = 1

func _ready() -> void:
	attackSpeedTimer.wait_time = attackSpeed

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right", "move_up", "move_down")
	if direction.length() > 0:
		look_at(global_position + direction)

func shoot():
	const ZONE = preload("res://scenes/Weapons/Zones/yolk.tscn")
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
	currentlvl += 1
	
	zoneDmgMult *= 1.1
	zoneIntMult *= 0.9
	attackSpeed *= 0.9
	attackSpeedTimer.wait_time = attackSpeed
	
	if currentlvl % 5 == 0:
		zoneScaMult *= 1.25
		zoneDurMult *= 1.25
