extends Area2D

@onready var attackSpeedTimer = %Timer
@export var attackSpeed = 0.5
@export var shotCount = 3
@export var statusEffectDisabled = false
@export var duration = 1.0

@onready var shooting_points = [
	%ShootingPoint, 
	%ShootingPoint2, 
	%ShootingPoint3, 
	%ShootingPoint4, 
	%ShootingPoint5,
	%ShootingPoint6,
	%ShootingPoint7
]
var rotation_offsets = [0.0, -0.1, 0.1, 0.2, -0.2, 0.3, -0.3]

func _ready() -> void:
	attackSpeedTimer.wait_time = attackSpeed

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0.0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func shoot():
	const BUCKSHOT = preload("res://scenes/Weapons/Projectiles/Range_Chonk_ShotgunBuckshot.tscn")
	for i in shotCount:
		var shooting_point = shooting_points[i]
		var rotation_offset = rotation_offsets[i]
		
		var new_shot = BUCKSHOT.instantiate()
		new_shot.global_position = shooting_point.global_position
		new_shot.global_rotation = shooting_point.global_rotation + rotation_offset
		shooting_point.add_child(new_shot)

func _on_timer_timeout() -> void:
	shoot()

func level_up():
	pass
