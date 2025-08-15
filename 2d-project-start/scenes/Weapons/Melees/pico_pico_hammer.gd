extends Area2D

@export var w_name: String = "Chonk's Hammer"
@export var weapon_icon: Texture2D
@onready var attackSpeedTimer = $Timer
@export var attackSpeed = 1.5
@export var statusEffectDisabled = false
@export var duration = 2.5
var attackDuration = 0.6
var attackDuration_time_elapsed = 0.0
var target_enemy
var enemies_in_range
var random_enemy
var currentLvl = 1.0

@onready var all_hit_visuals = [
	%Hit,
	%Hit2,
	%Hit3,
	%Hit4
]
var active_hit_visuals = []

@onready var all_melee_points = [
	%MeleePoint,
	%MeleePoint2,
	%MeleePoint3,
	%MeleePoint4
]
var active_melee_points = []


func _ready() -> void:
	active_hit_visuals.append(all_hit_visuals[0])
	active_melee_points.append(all_melee_points[0])

	for hit_visual in all_hit_visuals:
		hit_visual.disabled = statusEffectDisabled
		hit_visual.hide()
	
	attackSpeedTimer.wait_time = attackSpeed
	attackSpeedTimer.start()


func _physics_process(delta: float) -> void:
	attackDuration_time_elapsed += delta
	enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0.0:
		random_enemy = (randi() % enemies_in_range.size())
		target_enemy = enemies_in_range[random_enemy]
	
	if attackDuration_time_elapsed >= attackDuration:
		for hit_visual in active_hit_visuals:
			hit_visual.hide()
			
	for i in range(active_hit_visuals.size()):
		active_hit_visuals[i].global_position = active_melee_points[i].global_position
		active_hit_visuals[i].global_rotation = active_melee_points[i].global_rotation


func attack():
	$HammerASP.play()
	if enemies_in_range.size() > 0:
		look_at(target_enemy.global_position)
		
	for hit_visual in active_hit_visuals:
		hit_visual.show()
		hit_visual.hit()
		hit_visual.play_animation()
		
	attackDuration_time_elapsed = 0.0


func _on_timer_timeout() -> void:
	attack()


func level_up():
	currentLvl += 1
	attackSpeed *= 0.9
	attackSpeedTimer.wait_time = attackSpeed
	
	for hit_visual in active_hit_visuals:
		hit_visual.damage *= 1.1

	if currentLvl in [5, 10, 15]:
		var index = currentLvl / 5
		if index < all_hit_visuals.size():
			active_hit_visuals.append(all_hit_visuals[index])
			active_melee_points.append(all_melee_points[index])
	elif currentLvl % 5 == 0:
		self.scale *= 1.25
