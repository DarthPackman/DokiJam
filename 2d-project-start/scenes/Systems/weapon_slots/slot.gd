# slot.gd
extends PanelContainer
class_name WeaponSlot

signal request_swap(from_index: int, to_index: int)
signal request_assign(index: int, weapon_scene: PackedScene)

@export var weapon: PackedScene = null:
	set(value):
		weapon = value  # Use the property name directly
		if is_inside_tree():
			_update_visuals()
		else:
			call_deferred("_update_visuals")
			
func _ready() -> void:
	_update_visuals()

func _get_index() -> int:
	var parent := get_parent()
	if parent == null:
		return -1
	var children := parent.get_children()
	return children.find(self)

func _update_visuals() -> void:
	var icon_node := get_node_or_null("Icon")        # TextureRect or TextureButton
	var level_badge := get_node_or_null("LevelBadge") # Label

	if weapon:
		if icon_node:
			icon_node.self_modulate = Color(0.9, 0.9, 1.0, 1.0)  # equipped tint
		if level_badge:
			level_badge.text = "1"  # dummy testing value
			level_badge.visible = true
	else:
		if icon_node:
			icon_node.self_modulate = Color(0.15, 0.15, 0.15, 1.0)  # empty tint
			# icon_node.texture = null  # uncomment if you want to clear a texture
		if level_badge:
			level_badge.text = ""
			level_badge.visible = false

func get_drag_data(at_position: Vector2) -> Variant:
	if weapon == null:
		return null
	var preview := duplicate(DUPLICATE_USE_INSTANTIATION | DUPLICATE_SCRIPTS)
	set_drag_preview(preview)
	return {
		"type": "weapon",
		"scene": weapon,
		"source": self,
		"slot_index": _get_index()
	}

func can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY \
		and data.get("type", "") == "weapon" \
		and data.get("scene", null) is PackedScene

func drop_data(at_position: Vector2, data: Variant) -> void:
	if not can_drop_data(at_position, data):
		return

	var incoming_scene: PackedScene = data["scene"]
	var to_index := _get_index()
	var from_index := int(data.get("slot_index", -1))

	# If dragging from another slot, let the grid handle swap so weapon_order stays in sync.
	if from_index >= 0 and from_index != to_index:
		emit_signal("request_swap", from_index, to_index)
		return

	# If dragging from an external palette item, assign locally and notify grid.
	if from_index < 0:
		weapon = incoming_scene
		emit_signal("request_assign", to_index, incoming_scene)
