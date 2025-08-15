extends Control
class_name NewWeaponOrderUI

signal order_changed(new_order: Array)

@onready var slot_container: Control = $SlotContainer
var player: Node
var weapon_slots: Array[WeaponOrderSlot] = []
var selected_slot: WeaponOrderSlot = null

func _ready() -> void:
	_setup_slots()

func initialize() -> void:
	"""Public method to initialize from external systems (pause menu, etc.)"""
	_find_player()
	if player:
		_load_weapon_order()
	else:
		push_warning("NewWeaponOrderUI: Player not found during initialization")

func _find_player() -> void:
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_warning("Player not found")

func _setup_slots() -> void:
	# Collect all WeaponSlot children
	for child in slot_container.get_children():
		if child is WeaponOrderSlot:
			weapon_slots.append(child)
	
	# Connect signals and set slot numbers for each slot
	for i in range(weapon_slots.size()):
		var slot = weapon_slots[i]
		
		# Connect to the slot's gui_input signal directly
		if not slot.gui_input.is_connected(_on_slot_clicked):
			slot.gui_input.connect(_on_slot_clicked.bind(slot))
		
		# Connect hover signals
		if not slot.mouse_entered.is_connected(_on_slot_hover):
			slot.mouse_entered.connect(_on_slot_hover.bind(slot, true))
		if not slot.mouse_exited.is_connected(_on_slot_hover):
			slot.mouse_exited.connect(_on_slot_hover.bind(slot, false))
		
		# Set the slot number (1, 2, 3, 4 instead of 0, 1, 2, 3)
		slot.set_slot_number(i + 1)

func _load_weapon_order() -> void:
	if not player:
		return
	
	print("[NewWeaponOrderUI] Loading weapon order from player")
	
	# Update each slot with player's weapon data
	for i in range(min(4, weapon_slots.size())):
		var weapon_node = null
		if i < player.weapon_slots.size():
			weapon_node = player.weapon_slots[i]
		
		weapon_slots[i].set_weapon_node(weapon_node)
	print("WeaponOrderUI - Current:", player.weapon_slots)

func _on_slot_clicked(event: InputEvent, slot: WeaponOrderSlot) -> void:
	if not event is InputEventMouseButton:
		return
	
	var mouse_event = event as InputEventMouseButton
	if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
		return
	
	if selected_slot == null:
		# First click - select slot
		_select_slot(slot)
	elif selected_slot == slot:
		# Click same slot - deselect
		_deselect_slot()
	else:
		# Click different slot - swap
		_swap_weapons(selected_slot, slot)
		_deselect_slot()

func _on_slot_hover(slot: WeaponOrderSlot, is_hovering: bool) -> void:
	# Only apply hover if not selected (let the slot handle its own visual state)
	if selected_slot != slot:
		pass  # The slot handles its own hover state now

func _select_slot(slot: WeaponOrderSlot) -> void:
	selected_slot = slot
	# We need to add a selection method to the slot since we removed set_selected_state
	_highlight_selected_slot(slot, true)

func _deselect_slot() -> void:
	if selected_slot:
		_highlight_selected_slot(selected_slot, false)
		selected_slot = null

func _highlight_selected_slot(slot: WeaponOrderSlot, is_selected: bool) -> void:
	# Since we removed the highlight system, we'll use a different approach
	# We can add a border or change the background color to indicate selection
	if is_selected:
		slot.background.color = Color(0.4, 0.6, 1.0, 1)  # Bright blue for selection
	else:
		slot.background.color = slot.normal_color  # Back to normal

func _swap_weapons(slot_a: WeaponOrderSlot, slot_b: WeaponOrderSlot) -> void:
	if not player:
		return
	
	var index_a = weapon_slots.find(slot_a)
	var index_b = weapon_slots.find(slot_b)
	
	if index_a == -1 or index_b == -1:
		return
	
	print("[NewWeaponOrderUI] Swapping weapons between slot ", index_a + 1, " and slot ", index_b + 1)
	
	# Ensure weapon_slots array is large enough
	while player.weapon_slots.size() <= max(index_a, index_b):
		player.weapon_slots.append(null)
	
	# Swap in player's weapon_slots array
	var temp = player.weapon_slots[index_a]
	player.weapon_slots[index_a] = player.weapon_slots[index_b]
	player.weapon_slots[index_b] = temp
	
	# Update visual display
	slot_a.set_weapon_node(player.weapon_slots[index_a])
	slot_b.set_weapon_node(player.weapon_slots[index_b])
	
	# Emit signal for other systems
	order_changed.emit(player.weapon_slots.duplicate())
	
	# Update player UI if method exists
	if player.has_method("_update_weapon_slots_ui"):
		player._update_weapon_slots_ui()
	print("WeaponOrderUI - New:", player.weapon_slots)

# Public API
func refresh_display() -> void:
	"""Refresh the display with current player data"""
	if not player:
		_find_player()
	_load_weapon_order()
