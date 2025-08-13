extends PanelContainer
class_name WeaponSlot

@export var weapon_name: String = "":
	set(value):
		weapon_name = value
		if is_inside_tree():
			_update_visuals()
		else:
			call_deferred("_update_visuals")

var slot_colors: Array[Color] = [
	Color(0.0, 0.0, 0.0, 0.7),
	Color(1.0, 0.0, 0.0, 0.7),
	Color(0.0, 1.0, 0.0, 0.7),
	Color(0.0, 0.0, 1.0, 0.7)
]

func _ready() -> void:
	# Input routing: parent receives, children ignore
	mouse_filter = Control.MOUSE_FILTER_STOP
	var margin := get_node_or_null("Margin")
	if margin: margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var icon := get_node_or_null("Margin/Icon")
	if icon: icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var name_label := get_node_or_null("Margin/WeaponName")
	if name_label: name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE

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
	var icon_node := get_node_or_null("Margin/Icon")
	var badge := get_node_or_null("Margin/WeaponName")
	if weapon_name:
		if badge:
			badge.text = weapon_name
			badge.visible = true
		if icon_node:
			icon_node.color = Color(0.8, 0.8, 0.8, 0.0)
	else:
		if badge:
			badge.text = "Empty"
			badge.visible = true
		if icon_node:
			icon_node.color = Color(0.15, 0.15, 0.15, 0.0)

func _notification(what):
	if what == NOTIFICATION_PARENTED:
		_set_default_slot_color()

func set_weapon_display(weapon_name_param: String) -> void:
	weapon_name = weapon_name_param
