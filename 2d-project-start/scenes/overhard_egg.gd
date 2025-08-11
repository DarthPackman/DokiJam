extends Area2D

@onready var attackSpeedTimer = $Timer
@export var attackSpeed = 0.5
var duration = 0.1
var duration_time_elapsed = 0.0
@onready var hit_visuals = %EggSlap
@onready var hit_visuals2 = %EggSlap2
@onready var meleePoint = %MeleePoint
@onready var meleePoint2 = %MeleePoint2

func _ready() -> void:
	attackSpeedTimer.wait_time = attackSpeed

func _physics_process(delta: float) -> void:
	duration_time_elapsed += delta
	if duration_time_elapsed >= duration:
		hit_visuals.hide()
		hit_visuals2.hide()
		
func attack():
	hit_visuals.global_position = meleePoint.global_position
	hit_visuals.global_rotation = meleePoint.global_rotation
	hit_visuals.show()
	hit_visuals.hit()
	hit_visuals2.global_position = meleePoint2.global_position
	hit_visuals2.global_rotation = meleePoint2.global_rotation
	hit_visuals2.show()
	hit_visuals2.hit()
	duration_time_elapsed = 0.0
	

func _on_timer_timeout() -> void:
	attack()
