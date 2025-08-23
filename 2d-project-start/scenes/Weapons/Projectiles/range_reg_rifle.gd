extends Area2D

@onready var attackSpeedTimer = $Timer
@export var w_name: String = "Reg's Revolver"
@export var weapon_icon: Texture2D
@export var attackSpeed = 0.74
@export var statusEffectDisabled = false
@export var duration = 1.5
var currentLvl = 1
var lvlDmgMult = 1
var lvlScaleMult = 1
var bulletCount = 1

func _ready() -> void:
	attackSpeedTimer.wait_time = attackSpeed

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0.0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func shoot():
	$RevolverASP.play()
	const PROJECTILE = preload("res://scenes/Weapons/Projectiles/Range_Reg_Riflebullet.tscn")
	var new_projectile = PROJECTILE.instantiate()
	new_projectile.global_position = %ShootingPoint.global_position
	new_projectile.global_rotation = %ShootingPoint.global_rotation
	new_projectile.damage *= lvlDmgMult
	new_projectile.scale *= lvlScaleMult
	new_projectile.disabled = statusEffectDisabled
	get_tree().root.add_child(new_projectile)

func _on_timer_timeout() -> void:
	for bullet in bulletCount:
		shoot()

func level_up():
	currentLvl += 1
	lvlDmgMult *= 1.1
	attackSpeed *= 0.9
	attackSpeedTimer.wait_time = attackSpeed
	
	if currentLvl > 25 and currentLvl % 5.0 == 0.0:
		lvlScaleMult *= 1.25
	elif currentLvl % 5.0 == 0.0:
		bulletCount += 1
