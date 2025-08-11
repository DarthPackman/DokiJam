extends Area2D

var duration = 0.1
var duration_time_elapsed = 0.0
@onready var attackSpeedTimer = $Timer
@export var attackSpeed = 0.5
@onready var spear1_visuals = %Spear
@onready var spear2_visuals = %Spear2
@onready var meleePoint = %MeleePoint
@onready var meleePoint2 = %MeleePoint2

func _ready() -> void:
	attackSpeedTimer.wait_time = attackSpeed

func _physics_process(delta: float) -> void:
	duration_time_elapsed += delta
	if duration_time_elapsed >= duration:
		spear1_visuals.hide()
		spear2_visuals.hide()
		
func attack():
	spear1_visuals.global_position = meleePoint.global_position
	spear1_visuals.global_rotation = meleePoint.global_rotation
	spear2_visuals.global_position = meleePoint2.global_position
	spear2_visuals.global_rotation = meleePoint2.global_rotation
	duration_time_elapsed = 0.0
	spear1_visuals.show()
	spear2_visuals.show()
	spear1_visuals.hit()
	spear2_visuals.hit()
	
func _on_timer_timeout() -> void:
	attack()
