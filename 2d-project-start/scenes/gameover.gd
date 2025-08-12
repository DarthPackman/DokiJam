extends Control


func _on_retrybutton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/survivor_game.tscn")


func _on_menubutton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")
