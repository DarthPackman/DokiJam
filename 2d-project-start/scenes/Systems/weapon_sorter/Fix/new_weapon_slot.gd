extends Control
class_name WeaponOrderSlot

var weapon_node: Node = null
var slot_number: int = 1

# Visual state colors for the ColorRect background
var normal_color = Color(0.258824, 0.364706, 0.760784, 1)  # Your base blue color
var hover_color = Color(0.207059, 0.291765, 0.608627, 1)   # Darker blue for hover
var pressed_color = Color(0.310588, 0.437647, 0.912941, 1) # Lighter blue for pressed

@onready var icon: TextureRect = %Icon
@onready var weapon_label: Label = %WeaponName
@onready var slot_number_label: Label = %SlotNumber
@onready var background: ColorRect = $ColorRect

var is_pressed: bool = false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	background.color = normal_color
	_setup_weapon_label()
	_update_display()

func _setup_weapon_label() -> void:
	# Use the autowrap_mode from the scene (TextServer.AUTOWRAP_WORD_SMART)
	weapon_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	weapon_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_pressed = true
				background.color = pressed_color
			else:
				is_pressed = false
				if get_global_rect().has_point(get_global_mouse_position()):
					background.color = hover_color
				else:
					background.color = normal_color

func _mouse_entered() -> void:
	if not is_pressed:
		background.color = hover_color

func _mouse_exited() -> void:
	if not is_pressed:
		background.color = normal_color

func set_weapon_node(weapon: Node) -> void:
	weapon_node = weapon
	_update_display()

func set_slot_number(number: int) -> void:
	slot_number = number
	slot_number_label.text = str(slot_number)

func get_weapon_icon() -> Texture2D:
	"""Returns the weapon icon"""
	return icon.texture

func get_weapon_display_name() -> String:
	"""Returns the weapon display name"""
	if weapon_node:
		return weapon_node.get("w_name") if "w_name" in weapon_node else weapon_node.name
	return "Empty"

func _format_weapon_text(name: String, level: int) -> String:
	"""Format weapon text with manual line break"""
	return name + "\n(Lvl " + str(level) + ")"

func _update_display() -> void:
	if not is_node_ready():
		await ready
	
	if weapon_node:
		var display_name = weapon_node.get("w_name") if "w_name" in weapon_node else weapon_node.name
		var level = weapon_node.get("currentLvl") if "currentLvl" in weapon_node else 1
		var weapon_icon = weapon_node.get("weapon_icon") if "weapon_icon" in weapon_node else null
		
		weapon_label.text = _format_weapon_text(display_name, level)
		icon.texture = weapon_icon if weapon_icon is Texture2D else null
	else:
		# Empty slot
		weapon_label.text = "Empty"
		icon.texture = null
