extends Control


func _on_playbutton_pressed() -> void:
	Autoload.button_click()
	get_tree().change_scene_to_file("res://scenes/pickbird.tscn")

func _on_optionsbutton_pressed() -> void:
	Autoload.button_click()
	get_tree().change_scene_to_file("res://scenes/options.tscn")

func _on_quitbutton_pressed() -> void:
	Autoload.button_click()
	get_tree().quit()

func _on_button_mouse_entered() -> void:
	Autoload.button_hover()
