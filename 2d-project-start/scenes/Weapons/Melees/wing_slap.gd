extends Area2D

@onready var attackSpeedTimer = $Timer
@export var statusEffectDisabled = false
@export var attackSpeed = 1.5
@export var duration = 2.5
var attackDuration = 0.6
var attackDuration_time_elapsed = 0.0
@onready var hit_visuals = %Slap
@onready var meleePoint = %MeleePoint

func _ready() -> void:
	hit_visuals.disabled = statusEffectDisabled
	attackSpeedTimer.wait_time = attackSpeed

func _physics_process(delta: float) -> void:
	attackDuration_time_elapsed += delta
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0.0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)
	if attackDuration_time_elapsed >= attackDuration:
		hit_visuals.hide()
	hit_visuals.global_position = meleePoint.global_position
	hit_visuals.global_rotation = meleePoint.global_rotation
		
func attack():
	hit_visuals.show()
	hit_visuals.hit()
	hit_visuals.play_animation()
	attackDuration_time_elapsed = 0.0

func _on_timer_timeout() -> void:
	attack()

func level_up():
	pass
