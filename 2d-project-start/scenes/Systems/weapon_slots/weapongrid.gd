# Optimized WeaponGrid
extends HBoxContainer
class_name WeaponGrid

signal order_changed(new_order: Array)

@export var slots_count: int = 4
@export var starting_weapons: Array = [] # Array of PackedScene

var weapon_order: Array = [] # Array of PackedScene

func _ready() -> void:
	weapon_order.resize(slots_count)

	var slots := _get_slots()
	
	# Connect slot signals first
	for i in range(slots.size()):
		var slot = slots[i] # WeaponSlot
		if slot.has_signal("request_swap") and not slot.is_connected("request_swap", _on_slot_request_swap):
			slot.connect("request_swap", _on_slot_request_swap)
		if slot.has_signal("request_assign") and not slot.is_connected("request_assign", _on_slot_request_assign):
			slot.connect("request_assign", _on_slot_request_assign)
	
	# Apply weapons
	if starting_weapons.size() > 0:
		for i in range(slots_count):
			var w = starting_weapons[i] if i < starting_weapons.size() else null
			weapon_order[i] = w
			if i < slots.size():
				slots[i].weapon = w
	else:
		# Leave current slot values as-is (e.g., set by Player), just mirror to weapon_order
		for i in range(slots_count):
			var w = slots[i].weapon if i < slots.size() else null
			weapon_order[i] = w
	
	emit_signal("order_changed", weapon_order.duplicate())

func _get_slots() -> Array:
	return get_children()

func _on_slot_request_swap(from_index: int, to_index: int) -> void:
	if from_index < 0 or to_index < 0 or from_index == to_index:
		return

	var slots := _get_slots()
	if from_index >= slots.size() or to_index >= slots.size():
		return

	var tmp = weapon_order[from_index]
	weapon_order[from_index] = weapon_order[to_index]
	weapon_order[to_index] = tmp

	var from_slot = slots[from_index]
	var to_slot = slots[to_index]
	var tmp_w = from_slot.weapon
	from_slot.weapon = to_slot.weapon
	to_slot.weapon = tmp_w

	emit_signal("order_changed", weapon_order.duplicate())

func _on_slot_request_assign(index: int, weapon_scene: PackedScene) -> void:
	if index < 0 or index >= slots_count:
		return
	var slots := _get_slots()
	weapon_order[index] = weapon_scene
	if index < slots.size():
		slots[index].weapon = weapon_scene
	emit_signal("order_changed", weapon_order.duplicate())

func set_weapons(new_weapons: Array) -> void:
	var slots := _get_slots()
	for i in range(slots_count):
		var w = new_weapons[i] if i < new_weapons.size() else null
		weapon_order[i] = w
		if i < slots.size():
			slots[i].weapon = w
	emit_signal("order_changed", weapon_order.duplicate())

func get_order() -> Array:
	return weapon_order
