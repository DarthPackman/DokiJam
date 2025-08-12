extends Node2D

@onready var spawnTimer = $MobSpawnTimer
@onready var timerLabel = $CanvasLayer2/Timer
var difficulty = 0
var activeTime = 0

func _process(delta: float) -> void:
	activeTime += delta
	var minutes = floor(activeTime/60)
	var seconds = fmod(activeTime, 60)
	timerLabel.text = "%02d:%02d" % [minutes, seconds]
	if minutes == 10:
		difficulty = 1
	elif minutes == 20:
		difficulty = 2
	if difficulty == 1: 
		spawnTimer.wait_time = 0.2
	elif difficulty == 2:
		spawnTimer.wait_time = 0.1

	if minutes == 7:
		triggerEvent()
	elif minutes == 14:
		triggerEvent()
	elif minutes == 21:
		triggerEvent()
	elif minutes == 28:
		triggerEvent()

func spawn_mob():
	var reg_mob = preload("res://scenes/Enemies/RegMob.tscn")
	var slow_mob = preload("res://scenes/Enemies/SlowMob.tscn")
	var fast_mob = preload("res://scenes/Enemies/FastMob.tscn")
	var currentSpawn = randi() % 3
	var new_mob
	
	if currentSpawn == 0:
		new_mob = reg_mob.instantiate()
		new_mob.exp_amt = 10
	elif currentSpawn == 1:
		new_mob = slow_mob.instantiate()
		new_mob.exp_amt = 15
	elif currentSpawn == 2:
		new_mob = fast_mob.instantiate()
		new_mob.exp_amt = 2
	
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

func _on_timer_timeout() -> void:
	spawn_mob()

func _on_player_health_depleted() -> void:
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")
	

func _on_button_pressed() -> void:
	get_tree().quit()

func triggerEvent():
	pass
