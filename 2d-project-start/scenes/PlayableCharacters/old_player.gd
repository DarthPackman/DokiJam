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

# Weapons List Management (list-based selection)
@onready var weapons_container: Node = %Weapons
@export var default_weapon_index: int = 0  # 0 = first weapon in list
var weapons_list: Array[Node] = []

const WEAPON_NAMES := [  
	"a_reg_aura",           # 0  
	"a_ch_Burp",            # 1  
	"a_lo_Hoola",           # 2  
	"a_egg_RottenEgg",      # 3  
	"r_ch_shotgun",         # 4  
	"r_egg_hbe",            # 5  
	"r_lo_bow",             # 6  
	"r_reg_rifle",          # 7  
	"m_lo_spear",           # 8  
	"m_egg_OverhardEgg",    # 9  
	"m_ch_PicoPicoHammer",  # 10  
	"m_r_WingSlap",         # 11  
]

var active_weapons: Array[Node] = []
var max_active_weapons: int = 4

# Weapon Slots
@onready var weapon_grid = %WeaponGrid
@export var weapon_grid_path: NodePath  
var default_weapon_scene: PackedScene = preload("res://scenes/Weapons/Projectiles/Range_Long_Bow.tscn")

func _set_node_active_slots(node: Node, active: bool) -> void:
	# Areas
	if node is Area2D:
		node.monitoring = active
		node.monitorable = active
	
	# Timers - FIXED: Always stop first, then conditionally start
	elif node is Timer:
		node.stop()  # Always stop first
		if active:
			node.paused = false
			node.start()
		else:
			node.paused = true  # Keep paused when inactive
	
	# Recurse to children
	for child in node.get_children():
		_set_node_active(child, active)

func _ready() -> void:
	#specify the dragoon, add your function here from the select screen
	character = %RegularDragoon
	
	# sets up the leveling system
	level_up.connect(_on_level_up)  
	level_up_screen.upgrade_selected.connect(_on_upgrade_selected)
	
	_build_weapons_list_and_apply_default()
	
	# sets up the weapon grid system
	call_deferred("_apply_default_weapon")  
	call_deferred("_connect_weapon_grid_signals") # optional, but useful to re-equip on reorder  
  
	# Run debug + attach after the grid applies our loadout  
	call_deferred("_debug_dump_weapon_grid")  
	call_deferred("_ensure_weapon_instanced")
	
	#if weapon_grid:  
		#weapon_grid.connect("order_changed", _on_weapon_order_changed)  
		#var current_order = weapon_grid.get_order()  
		#print("Initial weapon order: ", current_order)

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
	if Input.is_action_just_pressed("ui_accept"):
		debug_add_exp()
		
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		for mob in overlapping_mobs:
			if mob.has_method("deal_damage"):
				health -= mob.damageDealt * delta
				%HPBar.value = health
		if health <= 0.0:
			health_depleted.emit()

###### EXP SYSTEM
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

func exp_gain(exp_amount: int) -> void:
	current_exp += exp_amount
	print("Gained ", exp_amount, " EXP! Total: ", current_exp, "/", exp_to_next_level)
	exp_tracker()

func collect_exp_orb(exp_amount: int) -> void:  
	exp_gain(exp_amount)  
	print("Collected EXP orb worth ", exp_amount, " EXP!")

# Exponential scaling: each level requires 20% more exp than the previous
func calculate_exp_requirement(level: int)->int:
	return int(20 * pow(1.2, level - 1))

func _on_level_up(new_level: int) -> void:  
	level_up_screen.show_upgrade_screen()

# Pressing space adds a 5 EXP for Testing
func debug_add_exp() -> void:
	exp_gain(10)
	print("TEST: Added 5 EXP via debug")

###### UPGRADE SYSTEM
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

###### Weapon list loadout so we can load the weapons as scenes

func _build_weapons_list_and_apply_default() -> void:
	if not weapons_container:
		push_warning("Weapons container not found")
		return

	weapons_list = weapons_container.get_children()
	if weapons_list.is_empty():
		push_warning("No weapons found")
		return

	# Initialize all weapons as inactive first (prevents Autostart timers)
	for weapon in weapons_list:
		_initialize_weapon_inactive(weapon)

	# Start only the default weapon
	if default_weapon_index >= 0 and default_weapon_index < weapons_list.size():
		_set_weapon_active(weapons_list[default_weapon_index], true)
		active_weapons = [weapons_list[default_weapon_index]]

	print("[Weapons] Active: ", active_weapons[0].name if not active_weapons.is_empty() else "None")

func _initialize_weapon_inactive(weapon: Node) -> void:
	# Immediately stop any auto-started timers without full activation logic
	weapon.set_process(false)
	weapon.set_physics_process(false)
	weapon.set_visible(false)

	for child in weapon.get_children():
		_stop_autostart_timers(child)

func _stop_autostart_timers(node: Node) -> void:
	if node is Timer:
		# Block signals and stop immediately to prevent autostart firing
		node.block_signals(true)
		node.stop()
		node.paused = true
	elif node is Area2D:
		node.monitoring = false
		node.monitorable = false

	for child in node.get_children():
		_stop_autostart_timers(child)

func _set_weapon_active(weapon: Node, active: bool) -> void:
	# Processing - stop first
	weapon.set_process(false)
	weapon.set_physics_process(false)

	# Visibility
	if weapon.has_method("set_visible"):
		weapon.set_visible(active)

	# Children (Timers/Areas) — make sure they're fully stopped/started
	for child in weapon.get_children():
		_set_node_active(child, active)

	# Re-enable processing only if active
	if active:
		weapon.set_process(true)
		weapon.set_physics_process(true)

func _set_node_active(node: Node, active: bool) -> void:
	if node is Area2D:
		node.monitoring = active
		node.monitorable = active
	elif node is Timer:
		if active:
			node.block_signals(false)
			node.paused = false
			node.start()
		else:
			# Block signals first to prevent queued timeouts from firing
			node.block_signals(true)
			node.stop()
			node.paused = true
	for child in node.get_children():
		_set_node_active(child, active)
