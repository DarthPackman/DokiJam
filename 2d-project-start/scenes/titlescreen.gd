extends Control


func _on_playbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/pickbird.tscn")

func _on_optionsbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")

func _on_quitbutton_pressed() -> void:
	get_tree().quit()
