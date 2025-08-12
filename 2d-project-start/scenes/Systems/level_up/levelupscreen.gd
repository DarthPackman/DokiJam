extends Control

signal upgrade_selected(upgrade_data: Dictionary)

@onready var upgrade_container: HBoxContainer = $VBoxContainer/UpgradeContainer
@onready var title_label: Label = $VBoxContainer/TitleLabel

var upgrade_options: Array = []
var input_locked := false

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	hide()

func show_upgrade_screen():
	if visible:
		return
	input_locked = false
	get_tree().paused = true
	_make_upgrade_options()
	_render_upgrade_boxes()
	show()
	grab_focus()

func _make_upgrade_options():
	upgrade_options = [
		{
			"type": "weapon",
			"name": "Weapon A",
			"description": "Shoots piercing fireballs.",
			"color": Color(1.0, 0.3, 0.2, 1.0)
		},
		{
			"type": "weapon",
			"name": "Weapon B",
			"description": "Egg",
			"color": Color(0.4, 0.8, 1.0, 1.0)
		},
		{
			"type": "weapon",
			"name": "Weapon C",
			"description": "Chonkybird",
			"color": Color(1.0, 0.95, 0.2, 1.0)
		},
		{
			"type": "weapon",
			"name": "Weapon D",
			"description": "Longbird.",
			"color": Color(0.9, 0.5, 1.0, 1.0)
		}
	]

func _render_upgrade_boxes():
	for c in upgrade_container.get_children():
		c.queue_free()

	for i in range(upgrade_options.size()):
		var box: Control = preload("res://scenes/Systems/level_up/UpgradeBox.tscn").instantiate()
		upgrade_container.add_child(box)
		box.call("setup_upgrade", upgrade_options[i], i)
		box.connect("upgrade_selected", _on_box_selected)

func _on_box_selected(data: Dictionary):
	if input_locked:
		return
	input_locked = true
	upgrade_selected.emit(data)
	_close()

func _close():
	hide()
	get_tree().paused = false

func _unhandled_input(event):
	if not visible or input_locked:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode >= KEY_1 and event.keycode <= KEY_4:
			var idx: int = event.keycode - KEY_1
			if idx < upgrade_options.size():
				_on_box_selected(upgrade_options[idx])
