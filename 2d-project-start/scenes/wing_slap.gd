extends Area2D

@onready var attackSpeedTimer = $Timer
@export var attackSpeed = 0.5
var duration = 0.1
var duration_time_elapsed = 0.0
@onready var slap_visuals = %Slap
@onready var meleePoint = %MeleePoint

func _ready() -> void:
	attackSpeedTimer.wait_time = attackSpeed

func _physics_process(delta: float) -> void:
	duration_time_elapsed += delta
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0.0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)
	if duration_time_elapsed >= duration:
		slap_visuals.hide()
		
func attack():
	slap_visuals.global_position = meleePoint.global_position
	slap_visuals.global_rotation = meleePoint.global_rotation
	slap_visuals.show()
	slap_visuals.hit()
	duration_time_elapsed = 0.0
	

func _on_timer_timeout() -> void:
	attack()
