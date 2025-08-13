extends Area2D

@onready var attackSpeedTimer = $Timer
@export var attackSpeed = 0.1
@export var statusEffectDisabled = false
@export var duration = 1.0

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
	new_zone.disabled = statusEffectDisabled
	get_tree().root.add_child(new_zone)

func _on_timer_timeout() -> void:
	shoot()

func level_up():
	pass
