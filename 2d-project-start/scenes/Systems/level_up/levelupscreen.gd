extends Control

signal upgrade_selected(upgrade_data: Dictionary)

@onready var upgrade_container: HBoxContainer = $VBoxContainer/UpgradeContainer
@onready var title_label: Label = $VBoxContainer/TitleLabel

var upgrade_options: Array = []
var input_locked := false
var player: Node = null

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	add_to_group("level_up_screen")
	hide()

func show_upgrade_screen():
	if visible:
		return
	input_locked = false
	get_tree().paused = true
	_find_player()
	_generate_options()
	show()
	grab_focus()

func _find_player() -> void:
	"""Locate the player node"""
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_warning("Player not found in group 'player'")

func weapon_lottery() -> Array:
	"""Generate weapon lottery options based on duplicate chance logic"""
	var weapon_options: Array = []
	
	# Create list of inactive weapons (pool) and duplicates (active weapons)
	var inactive_weapons: Array = []
	var duplicate_weapons: Array = []
	
	# Get all weapon nodes from player
	var all_weapons = player.get_children().filter(func(child): return child.name.begins_with("r_") or child.name.begins_with("a_") or child.name.begins_with("z_") or child.name.begins_with("m_"))
	
	for weapon in all_weapons:
		var is_active = false
		# Check if weapon is in active slots
		for slot_weapon in player.weapon_slots:
			if slot_weapon == weapon:
				is_active = true
				break
		
		if is_active:
			duplicate_weapons.append(weapon.name)
		else:
			inactive_weapons.append(weapon.name)
	
	print("Inactive weapons pool: ", inactive_weapons)
	print("Duplicate weapons pool: ", duplicate_weapons)
	
	# Count filled slots (active weapons)
	var filled_slots = 0
	for slot in player.weapon_slots:
		if slot != null:
			filled_slots += 1
	
	print("Filled slots: ", filled_slots)
	
	# 2. Use duplicate chance logic
	var duplicate_chance = 0.0
	if filled_slots < 4:
		duplicate_chance = 0.10  # 10% chance for duplicates
	else:
		duplicate_chance = 1.0   # upgrade only
	
	print("Duplicate chance: ", duplicate_chance * 100, "%")
	
	# Generate 4 weapon options
	for i in range(4):
		var selected_weapon: String
		
		# Roll for duplicate vs new weapon
		if randf() < duplicate_chance and duplicate_weapons.size() > 0:
			# Pick from duplicates
			selected_weapon = duplicate_weapons[randi() % duplicate_weapons.size()]
			print("Selected duplicate: ", selected_weapon)
		else:
			# Pick from inactive weapons
			if inactive_weapons.size() > 0:
				selected_weapon = inactive_weapons[randi() % inactive_weapons.size()]
				print("Selected new weapon: ", selected_weapon)
			else:
				# Fallback to duplicates if no inactive weapons available
				if duplicate_weapons.size() > 0:
					selected_weapon = duplicate_weapons[randi() % duplicate_weapons.size()]
					print("Fallback to duplicate: ", selected_weapon)
				else:
					print("ERROR: No weapons available!")
					continue
		
		weapon_options.append(selected_weapon)
	
	print("Final weapon options: ", weapon_options)
	return weapon_options

	## Dummy Upgrade 
	#weapon_options.clear()
	#weapon_options.append("r_lo_bow")
	#weapon_options.append("a_reg_aura")
	#weapon_options.append("z_ch_StoppyBoots")
	#weapon_options.append("z_egg_RunnyYolk")
	#print("levelupscreen", weapon_options)
	#return weapon_options

func _generate_options():
	if not player:
		_find_player()

	if not player:
		push_warning("Player not found - cannot generate upgrade options")
		return

	# Get weapon lottery results
	var lottery_weapons = weapon_lottery()
	
	# Get existing slots from UpgradeContainer
	var existing_slots = upgrade_container.get_children()
	
	# Iterate through lottery weapons and assign to slots
	for i in range(min(lottery_weapons.size(), existing_slots.size())):
		var weapon_name = lottery_weapons[i]
		var slot = existing_slots[i]
		
		# Access weapon node from player
		var weapon_node = player._get_weapon_node_by_name(weapon_name)
		if weapon_node:
			# Get weapon information
			var w_name = weapon_node.w_name
			var upgrade_level = 1
			var weapon_already_active = false
			for slot_weapon in player.weapon_slots:
				if slot_weapon == weapon_node:
					weapon_already_active = true
					break
			if weapon_already_active:
				# Weapon is active, return current level + 1
				upgrade_level = weapon_node.currentLvl + 1
				print("Upgraded Weapon Level: ", upgrade_level)
			else:
				# Weapon is not active, return current level
				upgrade_level = weapon_node.currentLvl
				print("Current Weapon Level: ", upgrade_level)

			var display_name = "%s (Lvl %d)" % [w_name, upgrade_level]
			var weapon_icon = weapon_node.weapon_icon
			
			# Just update the button visually
			slot.update_weapon_button(display_name, weapon_icon)
			
			# Connect for click feedback only
			if not slot.is_connected("pressed", _on_button_pressed):
				slot.connect("pressed", _on_button_pressed.bind(i))

func _on_button_pressed(index: int):
	print("Button ", index, " clicked!")

	# Validate index bounds
	var existing_slots = upgrade_container.get_children()
	if index < 0 or index >= existing_slots.size():
		push_warning("Invalid button index: ", index)
		return

	# Get weapon lottery results
	var lottery_weapons = weapon_lottery()
	if index >= lottery_weapons.size():
		push_warning("No weapon data for button index: ", index)
		return

	var weapon_name = lottery_weapons[index]
	var weapon_node = player._get_weapon_node_by_name(weapon_name)

	# Print out the display name of the weapon clicked
	var display_name = weapon_node.get("w_name") if weapon_node.has_method("get") and weapon_node.get("w_name") else weapon_name
	print("Weapon clicked: ", display_name)

	# Store the old level before leveling up
	var old_level = weapon_node.get("currentLvl") if weapon_node.has_method("get") and weapon_node.get("currentLvl") else 1

	# Call the weapon's level_up function
	if weapon_node.has_method("level_up"):
		# Check if weapon is already active in player's weapon slots
		var weapon_already_active = false
		for slot_weapon in player.weapon_slots:
			if slot_weapon == weapon_node:
				weapon_already_active = true
				break
		if weapon_already_active:
			# Weapon is active, level it up
			weapon_node.level_up()
			print("Leveled up active weapon: ", display_name)
			# Print out the level change (get actual new level after level_up)
			var new_level = weapon_node.get("currentLvl") if weapon_node.has_method(
				"get") and weapon_node.get("currentLvl") else old_level + 1
			print("Your weapon went from level ", old_level, " to ", new_level)
		else:
			# Weapon is not active, add it to player
			if player.add_weapon_to_slot(weapon_node, -1):
				print("Added new weapon to slot: ", display_name)
			else:
				print("Failed to add weapon - no available slots")
		
		player._update_weapon_slots_ui()
		

	else:
		push_warning("Weapon ", weapon_name, " does not have a level_up method")

	_close()

func _close():
	hide()
	get_tree().paused = false
