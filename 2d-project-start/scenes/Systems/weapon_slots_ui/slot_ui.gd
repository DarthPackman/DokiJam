extends PanelContainer
class_name WeaponSlot

@export var weapon_name: String = "":
	set(value):
		weapon_name = value
		if is_inside_tree():
			_update_visuals()
		else:
			call_deferred("_update_visuals")

var weapon_node: Node = null

# Default slot colors (slightly transparent)
var slot_colors: Array[Color] = [
	Color(0.0, 0.0, 0.0, 0.7),  # Black - Slot 0
	Color(1.0, 0.0, 0.0, 0.7),  # Red - Slot 1
	Color(0.0, 1.0, 0.0, 0.7),  # Green - Slot 2
	Color(0.0, 0.0, 1.0, 0.7)   # Blue - Slot 3
]

func _ready() -> void:
	_set_default_slot_color()
	_update_visuals()

func _get_slot_index() -> int:
	var parent := get_parent()
	if parent == null:
		return -1
	var children := parent.get_children()
	return children.find(self)

func _set_default_slot_color() -> void:  
	var slot_index = _get_slot_index()  
	if slot_index >= 0 and slot_index < slot_colors.size():  
		var sb := StyleBoxFlat.new()  
		sb.bg_color = slot_colors[slot_index]  
		set("theme_override_styles/panel", sb)

func _update_visuals() -> void:
	# Use the actual nodes from your slot.tscn structure
	var icon_node := get_node_or_null("Margin/Icon")  # ColorRect
	var badge := get_node_or_null("Margin/WeaponName")  # Label
	
	if weapon_node and is_instance_valid(weapon_node):
		# Weapon equipped - get w_name, currentLvl, and weapon_icon from weapon
		if badge:
			var display_name = "Unknown"
			var level = 1
			
			# Get w_name (weapon display name)
			if weapon_node.has_method("get") and "w_name" in weapon_node:
				display_name = weapon_node.w_name
			elif weapon_node.get("w_name") != null:
				display_name = weapon_node.get("w_name")
			else:
				display_name = weapon_node.name  # fallback to node name
			
			# Get currentLvl
			if weapon_node.has_method("get") and "currentLvl" in weapon_node:
				level = weapon_node.currentLvl
			elif weapon_node.get("currentLvl") != null:
				level = weapon_node.get("currentLvl")
			
			badge.text = display_name + " (Lvl " + str(level) + ")"
			badge.visible = true
		
		if icon_node:
			# Get weapon_icon if it exists
			var weapon_icon = null
			if weapon_node.has_method("get") and "weapon_icon" in weapon_node:
				weapon_icon = weapon_node.weapon_icon
			elif weapon_node.get("weapon_icon") != null:
				weapon_icon = weapon_node.get("weapon_icon")
			
			if weapon_icon and weapon_icon is Texture2D:
				# Set the icon as a texture instead of just color
				if icon_node is TextureRect:
					icon_node.texture = weapon_icon
				else:
					# If it's a ColorRect, make it semi-transparent to show equipped state
					icon_node.color = Color(0.8, 0.8, 0.8, 0.3)
			else:
				# No icon available, use semi-transparent color
				icon_node.color = Color(0.8, 0.8, 0.8, 0.3)
	else:
		# Empty slot
		if badge:
			badge.text = "Empty"
			badge.visible = true
		if icon_node:
			# Clear any texture and use transparent color for empty slot
			if icon_node is TextureRect:
				icon_node.texture = null
			icon_node.color = Color(0.15, 0.15, 0.15, 0.3)

func _notification(what):
	if what == NOTIFICATION_PARENTED:
		# Re-apply color when parent changes so index-based color stays correct
		_set_default_slot_color()

# Simple API for Player to call
func set_weapon_display(weapon_name_param: String) -> void:
	weapon_name = weapon_name_param

# New API for setting weapon node directly
func set_weapon_node(weapon: Node) -> void:
	weapon_node = weapon
	_update_visuals()
