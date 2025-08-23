extends Area2D

@onready var attackSpeedTimer = %Timer
@export var w_name: String = "Chonk's Shotgun"
@export var weapon_icon: Texture2D
@export var attackSpeed = 0.74
@export var shotCount = 3
@export var statusEffectDisabled = false
@export var duration = 1.5
var currentLvl = 1
var lvlDmgMult = 1
var lvlScaleMult = 1

@onready var shooting_points = [
	%ShootingPoint, 
	%ShootingPoint2, 
	%ShootingPoint3, 
	%ShootingPoint4, 
	%ShootingPoint5,
	%ShootingPoint6,
	%ShootingPoint7,
	%ShootingPoint8,
	%ShootingPoint9,
]

var rotation_offsets = [0.0, -0.1, 0.1, 0.2, -0.2, 0.3, -0.3, 0.4, -0.4]

func _ready() -> void:
	attackSpeedTimer.wait_time = attackSpeed
	attackSpeedTimer.start()

func _physics_process(delta: float) -> void:
	pass

func shoot():
	$ShotgunASP.play()
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0.0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)
	
	const BUCKSHOT = preload("res://scenes/Weapons/Projectiles/Range_Chonk_ShotgunBuckshot.tscn")
	
	for i in range(min(shotCount, shooting_points.size())):
		var shooting_point = shooting_points[i]
		var rotation_offset = rotation_offsets[i]
		
		var new_shot = BUCKSHOT.instantiate()
		new_shot.damage *= lvlDmgMult
		new_shot.scale *= lvlScaleMult
		new_shot.global_position = shooting_point.global_position
		new_shot.global_rotation = shooting_point.global_rotation + rotation_offset
		get_tree().root.add_child(new_shot)

func _on_timer_timeout() -> void:
	shoot()

func level_up():
	currentLvl += 1
	lvlDmgMult *= 1.1
	attackSpeed *= 0.9
	attackSpeedTimer.wait_time = attackSpeed
	
	if currentLvl % 5.0 == 0.0 and currentLvl > 20:
		lvlScaleMult *= 1.25
	if currentLvl % 5.0 == 0.0:
		shotCount += 2
