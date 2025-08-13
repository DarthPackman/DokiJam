extends Area2D

@onready var attackSpeedTimer = $Timer
@export var attackSpeed = 0.5
@export var statusEffectDisabled = false
@export var duration = 1.0
var currentLvl = 1
var lvlDmgMult = 1
var lvlScaleMult = 1
var arrowCount = 1

@onready var shooting_points = [
	%ShootingPoint,
	%ShootingPoint2,
	%ShootingPoint3
]

func _ready() -> void:
	attackSpeedTimer.wait_time = attackSpeed
	attackSpeedTimer.start()

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0.0:
		var target_enemy = enemies_in_range.back()
		look_at(target_enemy.global_position)

func shoot():
	const PROJECTILE = preload("res://scenes/Weapons/Projectiles/Range_Long_BowArrow.tscn")
	
	for i in range(arrowCount):
		if i < shooting_points.size(): 
			var shooting_point = shooting_points[i]
			var new_projectile = PROJECTILE.instantiate()
			new_projectile.damage *= lvlDmgMult
			new_projectile.scale *= lvlScaleMult
			new_projectile.global_position = shooting_point.global_position
			new_projectile.global_rotation = shooting_point.global_rotation
			new_projectile.disabled = statusEffectDisabled
			get_tree().root.add_child(new_projectile)

func _on_timer_timeout() -> void:
	shoot()

func level_up():
	currentLvl += 1
	lvlDmgMult *= 1.1
	attackSpeed *= 0.9
	attackSpeedTimer.wait_time = attackSpeed
	
	if currentLvl % 5 == 0 and currentLvl > 15:
		lvlScaleMult *= 1.25
	elif currentLvl % 5 == 0:
		arrowCount += 1
