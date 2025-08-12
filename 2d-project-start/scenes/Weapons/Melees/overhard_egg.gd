extends Area2D

@export var duration = 2.5
@onready var attackSpeedTimer = $Timer
@export var attackSpeed = 1.5
var attackDuration = 0.6
var attackDuration_time_elapsed = 0.0
@onready var hit_visuals = %EggSlap
@onready var hit_visuals2 = %EggSlap2
@onready var meleePoint = %MeleePoint
@onready var meleePoint2 = %MeleePoint2
@export var statusEffectDisabled = false

func _ready() -> void:
	hit_visuals.disabled = statusEffectDisabled
	attackSpeedTimer.wait_time = attackSpeed

func _physics_process(delta: float) -> void:
	attackDuration_time_elapsed += delta
	if attackDuration_time_elapsed >= attackDuration:
		hit_visuals.hide()
		hit_visuals2.hide()
	hit_visuals.global_position = meleePoint.global_position
	hit_visuals.global_rotation = meleePoint.global_rotation
	hit_visuals2.global_position = meleePoint2.global_position
	hit_visuals2.global_rotation = meleePoint2.global_rotation
		
func attack():
	hit_visuals.show()
	hit_visuals.hit()
	hit_visuals.play_animation()
	hit_visuals2.show()
	hit_visuals2.hit()
	hit_visuals2.play_animation()
	attackDuration_time_elapsed = 0.0

func _on_timer_timeout() -> void:
	attack()

func level_up():
	pass
