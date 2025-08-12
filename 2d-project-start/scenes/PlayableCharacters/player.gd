extends CharacterBody2D

signal health_depleted
var health = 100.0
var player_speed = 600
var character

# Experience system variables
@onready var level_up_screen: Control = %LevelUpScreen  
signal level_up(new_level: int)
var current_exp = 0
var current_level = 1
var exp_to_next_level = 20

@onready var exp_bar = %ExpBar

func _ready() -> void:
	character = %RegularDragoon
	level_up.connect(_on_level_up)  
	level_up_screen.upgrade_selected.connect(_on_upgrade_selected)

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right", "move_up", "move_down")
	velocity = direction * player_speed
	move_and_slide()
		
	if velocity.length() > 0.0:
		if direction.x == 1:
			character.get_node("AnimatedSprite2D").set_flip_h(true)
		elif direction.x == -1:
			character.get_node("AnimatedSprite2D").set_flip_h(false)
		character.play_walk_animation()
	else:
		character.play_idle_animation()
	
	# Debug EXP gain (toggleable)
	if Input.is_action_just_pressed("space"):  # Spacebar
		debug_add_exp()
		
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		for mob in overlapping_mobs:
			if mob.has_method("deal_damage"):
				health -= mob.damageDealt * delta
				%HPBar.value = health
		if health <= 0.0:
			health_depleted.emit()



func exp_gain(exp_amount: int) -> void:
	current_exp += exp_amount
	print("Gained ", exp_amount, " EXP! Total: ", current_exp, "/", exp_to_next_level)
	exp_tracker()

func collect_exp_orb(exp_amount: int) -> void:  
	exp_gain(exp_amount)  
	print("Collected EXP orb worth ", exp_amount, " EXP!")

# Pressing space adds a 5 EXP for Testing
func debug_add_exp() -> void:
	exp_gain(10)
	print("TEST: Added 5 EXP via debug")

# Exponential scaling: each level requires 20% more exp than the previous
func calculate_exp_requirement(level: int)->int:
	return int(20 * pow(1.2, level - 1))

func _on_level_up(new_level: int) -> void:  
	level_up_screen.show_upgrade_screen()

func _on_upgrade_selected(upgrade_data: Dictionary) -> void:  
	apply_upgrade(upgrade_data)  
  
func apply_upgrade(upgrade_data: Dictionary) -> void:  
	match upgrade_data.get("type", ""):  
		"weapon":  
			var name: String = upgrade_data.get("name", "Unknown") as String
			print("Added weapon: ", name)  
			# TODO: instantiate your weapon scenes here  
		"stat":  
			var name: String = upgrade_data.get("name", "Unknown") as String 
			print("Applied stat boost: ", name)  
			# TODO: modify player stats here  
		_:  
			print("Unknown upgrade type: ", upgrade_data)

func exp_tracker() -> void:
	var leveled = false  
	while current_exp >= exp_to_next_level:  
		current_exp -= exp_to_next_level  
		current_level += 1  
		exp_to_next_level = calculate_exp_requirement(current_level)  
		leveled = true  
		print("LEVEL UP! Now level ", current_level)  
		level_up.emit(current_level)  
	if exp_bar:  
		if leveled:  
			exp_bar.max_value = exp_to_next_level  
		exp_bar.value = clamp(current_exp, exp_bar.min_value, exp_bar.max_value)
