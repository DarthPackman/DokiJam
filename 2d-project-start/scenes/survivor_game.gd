extends Node2D

@onready var spawnTimer = $MobSpawnTimer
@onready var timerLabel = $CanvasLayer2/Timer
var difficulty = 0
var activeTime = 0

const DEFAULT_mult_speed : float = 1.0
const DEFAULT_mult_dam_dealt : float = 1.0
const DEFAULT_mult_dam_taken : float = 1.0
const DEFAULT_mult_exp : float = 1.0
const DEFAULT_mult_hp : float = 1.0

var mult_speed : float = 1.0
var mult_dam_dealt : float = 1.0
var mult_dam_taken : float = 1.0
var mult_exp : float = 1.0
var mult_hp : float = 1.0

var mutation_times = [1, 4, 7, 10]  
var victory_time = 15  
var triggered_events = {}
var boss_spawned = false
var minutes
var seconds

func _ready() -> void:
	Autoload.play_gameplay()

func _process(delta: float) -> void:
	activeTime += delta
	minutes = floor(activeTime/60)
	seconds = fmod(activeTime, 60)
	timerLabel.text = "%02d:%02d" % [minutes, seconds]
	if minutes == 5:
		difficulty = 1
	elif minutes == 10:
		difficulty = 2

	if difficulty == 1: 
		spawnTimer.wait_time = 0.2
	elif difficulty == 2:
		spawnTimer.wait_time = 0.1

# Check for mutation times  
	for time in mutation_times:  
		if minutes == time and not triggered_events.get(time, false):  
			mutation()  
			triggered_events[time] = true  
			break  # Only trigger one mutation per frame  
	# Check for victory time  
	if minutes == victory_time:  
		triggerVictory()  

		
func spawn_mob():
	var reg_mob = preload("res://scenes/Enemies/RegMob.tscn")
	var slow_mob = preload("res://scenes/Enemies/SlowMob.tscn")
	var fast_mob = preload("res://scenes/Enemies/FastMob.tscn")
	var boss_mob = preload("res://scenes/Enemies/BossRobot.tscn")
	var currentSpawn = randi() % 3
	var new_mob
	
	if minutes == 13 and not boss_spawned:
		new_mob = boss_mob.instantiate()
		boss_spawned = true
	elif currentSpawn == 0:
		new_mob = reg_mob.instantiate()
	elif currentSpawn == 1:
		new_mob = slow_mob.instantiate()
	elif currentSpawn == 2:
		new_mob = fast_mob.instantiate()
	
	#Mutation Factor for Each Round - Multipliers Exist
	new_mob.expMult = mult_exp
	new_mob.hpMult = mult_hp
	new_mob.speedMult = mult_speed
	new_mob.dmgTakenMult = mult_dam_taken
	new_mob.dmgDealtMult = mult_dam_dealt
	
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

func _on_timer_timeout() -> void:
	spawn_mob()

func _on_player_health_depleted() -> void:
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")

func triggerVictory():
	get_tree().change_scene_to_file("res://scenes/winscreen.tscn")

func _on_button_pressed() -> void:
	get_tree().quit()

func mutation():
	# reset to default
	mult_speed = DEFAULT_mult_speed
	mult_dam_dealt = DEFAULT_mult_dam_dealt 
	mult_dam_taken =DEFAULT_mult_dam_taken
	mult_exp = DEFAULT_mult_exp
	mult_hp = DEFAULT_mult_hp 
	# random mutation
	mult_speed = randf_range(0.1, 2.0)
	mult_dam_dealt = randf_range(0.1, 2.0) 
	mult_dam_taken = randf_range(0.1, 2.0)
	mult_exp = randf_range(0.1, 2.0)
	mult_hp = randf_range(0.1, 2.0)
	
	print("mult_speed: ", mult_speed, " mult_dam_dealt: ", 
	mult_dam_dealt, " mult_dam_taken: ", mult_dam_taken, 
	" mult_exp: ", mult_exp, " mult_hp: ", mult_hp)
