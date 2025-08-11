extends Area2D

@onready var attackSpeedTimer = $Timer
@export var attackSpeed = 0.5
@export var bounceCount = 3

func _ready() -> void:
	attackSpeedTimer.wait_time = attackSpeed

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0.0:
		var target_enemy = enemies_in_range.back()
		look_at(target_enemy.global_position)

func shoot():
	const BOILEDEGG = preload("res://scenes_weapons/Range_Egg_HBEProjectile.tscn")
	var new_egg = BOILEDEGG.instantiate()
	new_egg.global_position = %ShootingPoint.global_position
	new_egg.global_rotation = %ShootingPoint.global_rotation
	new_egg.bounceCount = bounceCount
	%ShootingPoint.add_child(new_egg)

func _on_timer_timeout() -> void:
	shoot()
