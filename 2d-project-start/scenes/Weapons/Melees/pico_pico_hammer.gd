extends Area2D

@onready var attackSpeedTimer = $Timer
@export var attackSpeed = 1.5
@export var statusEffectDisabled = false
@export var duration = 2.5
var attackDuration = 0.6
var attackDuration_time_elapsed = 0.0
@onready var hit_visuals = %Hit
@onready var meleePoint = %MeleePoint
var target_enemy
var enemies_in_range
var random_enemy

func _ready() -> void:
	hit_visuals.disabled = statusEffectDisabled
	attackSpeedTimer.wait_time = attackSpeed

func _physics_process(delta: float) -> void:
	attackDuration_time_elapsed += delta
	enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0.0:
		random_enemy = (randi() % enemies_in_range.size())
		target_enemy = enemies_in_range[random_enemy]
	if attackDuration_time_elapsed >= attackDuration:
		hit_visuals.hide()
	hit_visuals.global_position = meleePoint.global_position
	hit_visuals.global_rotation = meleePoint.global_rotation

func attack():
	if target_enemy:
		look_at(target_enemy.global_position)
	hit_visuals.show()
	hit_visuals.hit()
	hit_visuals.play_animation()
	attackDuration_time_elapsed = 0.0

func _on_timer_timeout() -> void:
	attack()

func level_up():
	pass
