extends CharacterBody2D

signal health_depleted
@export var health = 100
@export var player_speed = 600
var character
var defaultSpeed = 100

# Experience system variables
@onready var level_up_screen: Control = %LevelUpScreen  
signal level_up(new_level: int)
var current_exp = 0
var current_level = 1
var exp_to_next_level = 20
@onready var exp_bar = %ExpBar

# Multi-Weapon Slot System
@export var default_weapon_name: String 
var all_weapons: Array[Node] = []
var weapon_slots: Array[Node] = [null, null, null, null]  # 4 weapon slots
var max_weapon_slots: int = 4

# Weapon Slots
@onready var weapon_slots_ui = %NewWeaponSlotsUI  # HBoxContainer with 4 Slot children
signal weapon_slots_changed(weapon_names: Array[String])


func _ready() -> void:
	# Loads the player node into the group "player" for easier access anywhere
	add_to_group("player")
	# Specify the dragoon, add your function here from the select screen
	character = Autoload.character_selected.instantiate()
	$".".add_child(character)
	default_weapon_name = Autoload.default_weapon_name
	
	# Sets up the leveling system
	level_up.connect(_on_level_up)  
	
	# Initialize weapon system
	_initialize_weapon_system()
	#_populate_test_weapons() # test function - comment out to stop this from working
	#call_deferred("_test_start_firing_once_ready")  # test function do not use
	call_deferred("_start_firing_once_ready") 
	
	# Sets up the weapon grid system
	call_deferred("_initialize_weapon_slots_ui")

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

#### EXP SYSTEM ####
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

# Pressing space adds a 10 EXP for Testing
func debug_add_exp() -> void:
	exp_gain(10)
	print("TEST: Added 10 EXP via debug")

#### WEAPON FIRING SEQUENCE

# Sets up starting weapons for the character chosen
func _initialize_weapon_system() -> void:
	# Collect all available weapon nodes from the scene
	_collect_all_weapons()
	# Ensure all are inactive initially and clear slots
	_deactivate_all_weapons()
	# Set up default weapon in the first slot
	var default_weapon_node = _get_weapon_node_by_name(default_weapon_name)
	if default_weapon_node:
		add_weapon_to_slot(default_weapon_node, 0)  # Put default in slot 1 (index 0)
	else:
		push_warning("Default weapon '", default_weapon_name, "' not found!")

	# Activate all weapons currently in slots (only non-empty fire)
	#_activate_all_slot_weapons()

	_debug_dump_weapon_slots()

func _collect_all_weapons() -> void:
	all_weapons.clear()
	for child in get_children():
		if _is_probable_weapon(child):
			all_weapons.append(child)

func _is_probable_weapon(node: Node) -> bool:
	var n := node.name.to_lower()
	return n.begins_with("a_") or n.begins_with("r_") or n.begins_with("m_") or n.begins_with("z_")

func _get_weapon_node_by_name(weapon_name: String) -> Node:
	for weapon in all_weapons:
		if weapon.name == weapon_name:
			return weapon
	return null

func _deactivate_all_weapons() -> void:
	for weapon in all_weapons:
		_set_weapon_active(weapon, false)
	weapon_slots.fill(null)

# Fire the weapon sequence infinitely  
var is_firing_sequence: bool = false  
  
# Fire the weapon sequence infinitely (start once, then stop processing)  
func _start_firing_once_ready() -> void:    
	if is_firing_sequence:    
		return    
	is_firing_sequence = true    
	firing_seq()  
	
# Add this variable to your class
var firing_sequence_active: bool = true

func firing_seq() -> void:  
	while true:  
		# Check if node is still in tree (for scene changes)
		if not is_inside_tree():
			break
			
		# Check if game is paused before processing weapons  
		if get_tree().paused:  
			await get_tree().process_frame  # Wait one frame and check again  
			continue  
			  
		for i in range(weapon_slots.size()):
			# Check if node is still in tree
			if not is_inside_tree():
				return
				
			var weapon = weapon_slots[i]
			if weapon:
				# Check pause state before activating each weapon  
				if get_tree().paused:  
					break  # Exit weapon loop if paused  
					  
				var weapon_name = weapon.name  
				var weapon_duration = _get_weapon_duration(weapon)  
  
				print("Weapon ",i, " ", weapon_name, " is activated")  
				_set_weapon_active(weapon, true)  
  
				# Check pause during countdown  
				for countdown in range(int(weapon_duration), 0, -1):
					# Check if node is still in tree
					if not is_inside_tree():
						return
					if get_tree().paused:  
						break  # Exit countdown if paused  
					print("Weapon ", weapon_name, " firing... ", countdown, " seconds remaining")  
					await get_tree().create_timer(1.0).timeout  

				# Check if node is still in tree before deactivating
				if not is_inside_tree():
					return
				_set_weapon_active(weapon, false)  
				print("Weapon ", i, " ", weapon_name, " is deactivated")  
				print("Weapon delay is ", weapon_duration, " seconds")
				
				
func _get_weapon_duration(weapon: Node) -> float:
	"""Get the duration property from a weapon node, with fallback"""
	if weapon.has_method("get") and "duration" in weapon:
		return weapon.duration
	elif weapon.get("duration") != null:
		return weapon.get("duration")
	else:
		# Fallback to default duration if weapon doesn't have duration property
		push_warning("Weapon ", weapon.name, " doesn't have duration property, using default 10.0")
		return 10.0

func _set_weapon_active(weapon: Node, active: bool) -> void:
	"""Set a weapon's active state"""
	if not weapon:
		return
		
	# Set processing
	weapon.set_process(active)
	weapon.set_physics_process(active)
	
	# Set visibility
	weapon.set_visible(active)
	
	# Handle all child nodes (timers, areas, etc.)
	_set_weapon_children_active(weapon, active)

func _set_weapon_children_active(node: Node, active: bool) -> void:
	"""Recursively set active state for all children of a weapon"""
	for child in node.get_children():
		if child is Timer:
			if active:
				child.paused = false
				child.start()
			else:
				child.stop()
				child.paused = true
		elif child is Area2D:
			child.monitoring = active
			child.monitorable = active
		
		# Recurse to grandchildren
		_set_weapon_children_active(child, active)

# Adding weapons to the slot with the logic to look for the 1st empty slot

func add_weapon_to_slot(weapon_node: Node, slot_index: int = -1) -> bool:
	if not weapon_node:
		push_warning("Attempted to add a null weapon node.")
		return false

	var target_slot := slot_index
	if target_slot == -1:
		target_slot = get_first_empty_slot()

	if target_slot != -1 and target_slot < max_weapon_slots:
		if weapon_slots[target_slot] != null:
			_set_weapon_active(weapon_slots[target_slot], false)
			print("[Weapon Slots] Replaced slot ", target_slot, ": ", weapon_slots[target_slot].name, " -> ", weapon_node.name)
		else:
			print("[Weapon Slots] Added '", weapon_node.name, "' to slot ", target_slot)

		weapon_slots[target_slot] = weapon_node
		_update_weapon_slots_ui()
		return true

	push_warning("No available weapon slots or invalid slot index: ", slot_index)
	return false

func get_first_empty_slot() -> int:
	for i in range(max_weapon_slots):
		if weapon_slots[i] == null:
			return i
	return -1

# DEBUGGING FOR WEAPON SLOT ASSIGNMENT

# Prints out the weapon slots at the beginning
func _debug_dump_weapon_slots() -> void:
	print("--- Current Weapon Slots ---")
	var slots_to_show: int = min(max_weapon_slots, weapon_slots.size())
	for i in range(slots_to_show):
		var entry := weapon_slots[i]
		if entry and is_instance_valid(entry):
			var active := entry.is_processing() or entry.is_physics_processing()
			print("Slot ", i + 1, ": ", entry.name, " (active=", active, ")")
		else:
			print("Slot ", i + 1, ": Empty")
	print("---------------------------")

#Set weapons as active 
func _activate_all_slot_weapons() -> void:
	for weapon in weapon_slots:
		if weapon:
			_set_weapon_active(weapon, true)

# prints out the relevant weapons when you test them out
func firing_seq_test() -> void:
	while true:
		for i in range(weapon_slots.size()):
			var weapon = weapon_slots[i]
			if weapon:
				# Get weapon name and duration from the actual weapon
				var weapon_name = weapon.name
				var weapon_duration = _get_weapon_duration(weapon)

				print("Weapon ", i, " ",  weapon_name, " is activated")

				# Simulate weapon firing with countdown for each second
				for countdown in range(int(weapon_duration), 0, -1):
					print("Weapon ", weapon_name, " firing... ", countdown, " seconds remaining")
					await get_tree().create_timer(1.0).timeout

				print("Weapon ", i, " ",weapon_name, " is deactivated")
				print("Weapon delay is ", weapon_duration, " seconds")

# Fire the weapon sequence infinitely (start once, then stop processing)  
func _test_start_firing_once_ready() -> void:    
	if is_firing_sequence:    
		return    
	is_firing_sequence = true    
	firing_seq()  

func _populate_test_weapons() -> void:
	"""Fill remaining weapon slots (1..max-1) with specific weapon names for testing"""
	var test_weapon_names: Array[String] = ["z_egg_RunnyYolk","r_lo_bow","a_reg_aura"]  # Add your weapon names here for testing
	
	if test_weapon_names.is_empty():
		print("[TestWeapons] No test weapon names provided.")
		return

	var slot_index := 1  # keep slot 0 for default weapon
	for weapon_name in test_weapon_names:
		if slot_index >= max_weapon_slots:
			break
		if weapon_name == default_weapon_name:
			continue
		var weapon_node := _get_weapon_node_by_name(weapon_name)
		if weapon_node:
			add_weapon_to_slot(weapon_node, slot_index)
			slot_index += 1
		else:
			push_warning("[TestWeapons] Weapon not found: ", weapon_name)

	_debug_dump_weapon_slots()

#### WEAPON SLOTS UI SYSTEM ####

func _initialize_weapon_slots_ui() -> void:
	if not weapon_slots_ui:
		push_warning("WeaponSlotsUI not found")
		return
	_update_weapon_slots_ui()

func _update_weapon_slots_ui() -> void:
	if not weapon_slots_ui:
		return
	
	var slots = weapon_slots_ui.get_children()
	for i in range(min(4, slots.size())):
		var slot = slots[i]
		
		# Set the weapon node (automatically updates display name and icon)
		var weapon_node = null
		if i < weapon_slots.size() and weapon_slots[i]:
			weapon_node = weapon_slots[i]
		slot.set_weapon_node(weapon_node)
		
		# Update slot number (1-based)
		slot.set_slot_number(i + 1)

#### ORDERING MECHANICS TO UPDATE

# refreshes weapon order from the pause screen

func set_weapon_order(new_order: Array[String]) -> void:
	# Clear current slots
	for i in range(weapon_slots.size()):
		if weapon_slots[i]:
			_set_weapon_active(weapon_slots[i], false)
		weapon_slots[i] = null
	
	# Apply new order
	for i in range(min(new_order.size(), max_weapon_slots)):
		if new_order[i] != "":
			var weapon_node = _get_weapon_node_by_name(new_order[i])
			if weapon_node:
				weapon_slots[i] = weapon_node
	
	_update_weapon_slots_ui()
	print("Weapon order updated: ", new_order)
