extends Control

signal upgrade_selected(upgrade_data: Dictionary)

@onready var upgrade_container: HBoxContainer = $VBoxContainer/UpgradeContainer
@onready var title_label: Label = $VBoxContainer/TitleLabel

var upgrade_options: Array = []
var input_locked := false
var player: Node = null
var lottery_weapons = null

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
	# Initial weapon pool setup
	var inactive_weapons: Array = []
	var duplicate_weapons: Array = []
	var filled_slots = 0
	
	var all_weapons = player.get_children().filter(func(child): return child.name.begins_with("r_") or child.name.begins_with("a_") or child.name.begins_with("z_") or child.name.begins_with("m_"))
	
	# Categorize weapons and count filled slots
	for weapon in all_weapons:
		var is_active = weapon in player.weapon_slots
		if is_active:
			duplicate_weapons.append(weapon.name)
		else:
			inactive_weapons.append(weapon.name)
	
	for slot in player.weapon_slots:
		if slot != null:
			filled_slots += 1
	
	print("Inactive weapons pool: ", inactive_weapons)
	print("Duplicate weapons pool: ", duplicate_weapons)
	print("Filled slots: ", filled_slots)
	
	var duplicate_chance = 0.10 if filled_slots < 4 else 1.0
	print("Duplicate chance: ", duplicate_chance * 100, "%")
	
	var weapon_options: Array = []
	
	# Generate 4 unique weapons
	while weapon_options.size() < 4:
		var selected_weapon: String
		
		# Determine pool and select weapon
		if randf() < duplicate_chance and duplicate_weapons.size() > 0:
			selected_weapon = duplicate_weapons[randi() % duplicate_weapons.size()]
			print("Selected duplicate: ", selected_weapon)
		elif inactive_weapons.size() > 0:
			selected_weapon = inactive_weapons[randi() % inactive_weapons.size()]
			print("Selected new weapon: ", selected_weapon)
		else:
			print("ERROR: No weapons available!")
			break
		
		# Skip if weapon already selected
		if selected_weapon in weapon_options:
			continue
		
		# Remove from pools only after confirming it's unique
		if selected_weapon in duplicate_weapons:
			duplicate_weapons.erase(selected_weapon)
		elif selected_weapon in inactive_weapons:
			inactive_weapons.erase(selected_weapon)
	
		weapon_options.append(selected_weapon)
	
	print("Levelup: Generated lottery weapon list ", weapon_options)
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

	# Get weapon lottery results
	lottery_weapons = weapon_lottery()
	
	# Get existing slots from UpgradeContainer
	var existing_slots = upgrade_container.get_children()
	
	# Iterate through lottery weapons and assign to slots
	for i in range(min(lottery_weapons.size(), existing_slots.size())):
		var weapon_name = lottery_weapons[i]
		var slot = existing_slots[i]
		
		# Access weapon node from playerww
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
	print("Levelup: ", "Button ", index, " clicked!")
	print("Levelup: Checking list of  ", lottery_weapons)
	# Access the correct weapon from the generated lottery weapons
	var weapon_name = lottery_weapons[index]
	print("Levelup: You have chosen ", weapon_name)
	
	var weapon_node = player._get_weapon_node_by_name(weapon_name)

	# Print out the display name of the weapon clicked
	var display_name = weapon_node.w_name
	print("Weapon clicked: ", display_name)

	# Store the old level before leveling up
	var old_level = weapon_node.currentLvl

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
