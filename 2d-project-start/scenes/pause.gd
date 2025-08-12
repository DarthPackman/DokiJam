extends CanvasLayer

@onready var pause_menu = $"."

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()

func _toggle_pause() -> void:
	if pause_menu.visible:
		pause_menu.hide()
		get_tree().paused = false
	else:
		pause_menu.show()
		get_tree().paused = true

func _on_resume_button_pressed() -> void:
	_toggle_pause()

func _on_main_menu_button_pressed() -> void:
	_toggle_pause()
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
