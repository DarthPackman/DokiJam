extends Area2D

@onready var attackSpeedTimer = $Timer
@export var attackSpeed = 0.5
@export var statusEffectDisabled = false
@export var duration = 1.0

func _ready() -> void:
	attackSpeedTimer.wait_time = attackSpeed

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0.0:
		var target_enemy = enemies_in_range.back()
		look_at(target_enemy.global_position)

func shoot():
	const PROJECTILE = preload("res://scenes/Weapons/Projectiles/Range_Long_BowArrow.tscn")
	var new_projectile = PROJECTILE.instantiate()
	new_projectile.global_position = %ShootingPoint.global_position
	new_projectile.global_rotation = %ShootingPoint.global_rotation
	new_projectile.disabled = statusEffectDisabled
	get_tree().root.add_child(new_projectile)

func _on_timer_timeout() -> void:
	shoot()

func level_up():
	pass
