extends Area2D

@onready var attackSpeedTimer = $Timer
@export var attackSpeed = 0.75
@export var statusEffectDisabled = false
@export var duration = 1.0

func _ready() -> void:
	attackSpeedTimer.wait_time = attackSpeed

func _physics_process(delta: float) -> void:
	var random_x = randi() % int(get_viewport_rect().size.x)
	var random_y = randi() % int(get_viewport_rect().size.y)
	var random_position = Vector2(random_x, random_y)
	look_at(random_position)

func shoot():
	push_warning("Dropping")
	const ZONE = preload("res://scenes/Weapons/Zones/dragoondrop.tscn")
	var new_zone = ZONE.instantiate()
	new_zone.global_position = %LandingSpot.global_position
	new_zone.disabled = statusEffectDisabled
	get_tree().root.add_child(new_zone)

func _on_timer_timeout() -> void:
	shoot()

func level_up():
	pass
