extends Control


func _on_retrybutton_pressed() -> void:
	Autoload.button_click()
	get_tree().change_scene_to_file("res://scenes/survivor_game.tscn")


func _on_menubutton_pressed() -> void:
	Autoload.button_click()
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")


func _on_button_mouse_entered() -> void:
	Autoload.button_hover()
