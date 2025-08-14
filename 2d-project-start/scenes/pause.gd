extends CanvasLayer

@onready var pause_menu = $"."
@onready var weapon_order_ui: WeaponOrderUI = %WeaponOrderUI

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  
		# Check if level up screen is active before allowing pause  
		var level_up_screen = get_tree().get_first_node_in_group("level_up_screen")  
		if level_up_screen and level_up_screen.visible:  
			return  # Don't allow pause while level up screen is active  
		_toggle_pause()

func _toggle_pause() -> void:
	if pause_menu.visible:
		pause_menu.hide()
		get_tree().paused = false
	else:
		pause_menu.show()
		get_tree().paused = true
		# Initialize weapon cards when pause menu opens
		weapon_order_ui.initialize()

func _on_resume_button_pressed() -> void:
	_toggle_pause()

func _on_main_menu_button_pressed() -> void:
	_toggle_pause()
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
