extends Control

signal upgrade_selected(upgrade_data: Dictionary)

@onready var icon_rect: ColorRect = $VBoxContainer/IconContainer/Icon
@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var description_label: Label = $VBoxContainer/DescriptionLabel
@onready var button: Button = $Button

var upgrade_data: Dictionary = {}
var index_label: Label

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	button.pressed.connect(_on_pressed)

func setup_upgrade(data: Dictionary, index := 0) -> void:
	upgrade_data = data
	name_label.text = str(data.get("name", "Unknown"))
	description_label.text = str(data.get("description", ""))

	# Index overlay (1–4)
	if not index_label:
		index_label = Label.new()
		index_label.text = str(index + 1)
		index_label.add_theme_font_size_override("font_size", 16)
		index_label.modulate = Color(1, 1, 1, 0.7)
		add_child(index_label)
		index_label.position = Vector2(8, 6)

	# Color block instead of image
	icon_rect.color = data.get("color", Color(0.8, 0.8, 0.8, 1.0))

func _on_pressed():
	button.disabled = true
	emit_signal("upgrade_selected", upgrade_data)
