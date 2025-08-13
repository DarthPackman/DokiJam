extends Control
class_name WeaponOrderUI

signal order_changed(new_order: Array[String])

@onready var slot_container: Control = $SlotContainer

var player: Node = null
var slots: Array[WeaponSlot] = []
var weapon_order: Array[String] = ["", "", "", ""]

# Click-to-swap state
var selected_slot_index: int = -1
var drag_cursor: Control = null

func _ready() -> void:
	_setup_ui()

func _setup_ui() -> void:
	"""Initialize the weapon order UI"""
	_find_player()
	_collect_slots()
	_connect_slot_signals()
	_create_drag_cursor()

func initialize() -> void:
	"""Public method to initialize from external systems"""
	if not player:
		_find_player()
	refresh_from_player()

func refresh_from_player() -> void:
	"""Update UI to match player's current weapon order"""
	if not player:
		return
	if slots.is_empty():
		_collect_slots()

	# Sync weapon_order array with player data
	for i in range(min(4, slots.size())):
		var weapon_name := ""
		if i < player.weapon_slots.size() and player.weapon_slots[i]:
			weapon_name = player.weapon_slots[i].name
		weapon_order[i] = weapon_name
		slots[i].set_weapon_display(weapon_name)

func _find_player() -> void:
	"""Locate the player node"""
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_warning("Player not found in group 'player'")

func _collect_slots() -> void:
	"""Gather all weapon slot nodes"""
	print("[WeaponOrderUI] Collecting slots...")
	slots.clear()
	
	for child in slot_container.get_children():
		if child is WeaponSlot:
			slots.append(child)
	
	print("[WeaponOrderUI] Found", slots.size(), "weapon slots")

func _connect_slot_signals() -> void:
	"""Connect click handlers to all weapon slots"""
	print("[WeaponOrderUI] Connecting slot signals...")
	
	for i in range(slots.size()):
		var slot = slots[i]
		if slot == null:
			continue
			
		# Ensure slot receives mouse input
		slot.mouse_filter = Control.MOUSE_FILTER_STOP
		
		# Connect click events (disconnect first to avoid duplicates)
		if slot.gui_input.is_connected(_on_slot_clicked):
			slot.gui_input.disconnect(_on_slot_clicked)
		slot.gui_input.connect(_on_slot_clicked.bind(i))
		
		print("[WeaponOrderUI] Connected slot", i)
	
	print("[WeaponOrderUI] All slots connected")

func _create_drag_cursor() -> void:
	"""Create floating cursor that follows mouse during selection"""
	drag_cursor = Control.new()
	drag_cursor.name = "DragCursor"
	drag_cursor.mouse_filter = Control.MOUSE_FILTER_IGNORE
	drag_cursor.visible = false
	drag_cursor.z_index = 100
	
	# Background
	var bg = ColorRect.new()
	bg.color = Color(0.2, 0.6, 1.0, 0.8)
	bg.size = Vector2(100, 100)
	bg.position = Vector2(-50, -50)
	drag_cursor.add_child(bg)
	
	# Label
	var label = Label.new()
	label.text = "Dragging"
	label.position = Vector2(-30, -10)
	label.add_theme_color_override("font_color", Color.WHITE)
	drag_cursor.add_child(label)
	
	add_child(drag_cursor)

# === CLICK HANDLING ===

func _on_slot_clicked(event: InputEvent, slot_index: int) -> void:
	"""Handle weapon slot clicks for selection and swapping"""
	if not _is_valid_click(event):
		return
	
	print("[WeaponOrderUI] Slot", slot_index, "clicked")
	
	if selected_slot_index == -1:
		_start_selection(slot_index)
	else:
		if slot_index != selected_slot_index:
			_perform_swap(selected_slot_index, slot_index)
		_end_selection()

func _is_valid_click(event: InputEvent) -> bool:
	"""Check if event is a valid left mouse click"""
	if not event is InputEventMouseButton:
		return false
	var mouse_event = event as InputEventMouseButton
	return mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed

# === SELECTION SYSTEM ===

func _start_selection(slot_index: int) -> void:
	"""Begin weapon selection process"""
	print("[WeaponOrderUI] Starting selection of slot", slot_index)
	selected_slot_index = slot_index
	
	_highlight_slot(slot_index, true)
	_update_drag_cursor(weapon_order[slot_index])

func _end_selection() -> void:
	"""End weapon selection process"""
	print("[WeaponOrderUI] Ending selection")
	
	if selected_slot_index != -1:
		_highlight_slot(selected_slot_index, false)
	
	selected_slot_index = -1
	drag_cursor.visible = false

func _perform_swap(from_index: int, to_index: int) -> void:
	"""Swap weapons between two slots"""
	print("[WeaponOrderUI] Swapping slot", from_index, "with slot", to_index)
	
	if not _is_valid_swap(from_index, to_index):
		return
	
	# Swap in weapon_order array
	var temp = weapon_order[from_index]
	weapon_order[from_index] = weapon_order[to_index]
	weapon_order[to_index] = temp
	
	# Update visual displays
	slots[from_index].set_weapon_display(weapon_order[from_index])
	slots[to_index].set_weapon_display(weapon_order[to_index])
	
	# Notify systems of change
	_apply_new_order()

func _is_valid_swap(from_index: int, to_index: int) -> bool:
	"""Validate swap indices"""
	if from_index < 0 or from_index >= 4:
		return false
	if to_index < 0 or to_index >= 4:
		return false
	if from_index == to_index:
		return false
	return true

# === VISUAL FEEDBACK ===

func _highlight_slot(slot_index: int, highlight: bool) -> void:
	"""Highlight or unhighlight a weapon slot"""
	if slot_index < 0 or slot_index >= slots.size():
		return
	
	var slot = slots[slot_index]
	if highlight:
		slot.modulate = Color(1.2, 1.2, 1.2)
		print("[WeaponOrderUI] Highlighted slot", slot_index)
	else:
		slot.modulate = Color.WHITE
		print("[WeaponOrderUI] Unhighlighted slot", slot_index)

func _update_drag_cursor(weapon_name: String) -> void:
	"""Update drag cursor with current weapon info"""
	if not drag_cursor:
		return
	
	var label = drag_cursor.get_child(1) as Label
	if label:
		label.text = weapon_name if weapon_name != "" else "Empty"
	drag_cursor.visible = true

# === INPUT HANDLING ===

func _input(event: InputEvent) -> void:
	"""Handle global input events"""
	if selected_slot_index == -1:
		return
	
	# Update drag cursor position
	if event is InputEventMouseMotion:
		var mouse_event = event as InputEventMouseMotion
		drag_cursor.position = mouse_event.position
	
	# Cancel selection
	elif _is_cancel_input(event):
		_end_selection()

func _is_cancel_input(event: InputEvent) -> bool:
	"""Check if input should cancel current selection"""
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		return mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed
	elif event is InputEventKey:
		var key_event = event as InputEventKey
		return key_event.keycode == KEY_ESCAPE and key_event.pressed
	return false

# === ORDER MANAGEMENT ===

func _apply_new_order() -> void:
	"""Apply new weapon order to player and emit signals"""
	# Emit signal for external listeners
	order_changed.emit(weapon_order.duplicate())
	
	# Direct call to player if available
	if player and player.has_method("set_weapon_order"):
		player.set_weapon_order(weapon_order.duplicate())

# === PUBLIC API ===

func get_current_order() -> Array[String]:
	"""Get current weapon order"""
	return weapon_order.duplicate()

func set_weapon_order(new_order: Array[String]) -> void:
	"""Set new weapon order from external source"""
	if new_order.size() != 4:
		push_warning("Invalid weapon order size: " + str(new_order.size()))
		return
	
	weapon_order = new_order.duplicate()
	
	# Update slot displays
	for i in range(min(4, slots.size())):
		slots[i].set_weapon_display(weapon_order[i])
