extends Control

@onready var regidle = $Panel/MarginContainer/HBoxContainer2/TextureButton/regidle


func _on_selectreg_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/survivor_game.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")


func _on_texture_button_mouse_entered() -> void:
	pass # Replace with function body.



func _on_texture_button_mouse_exited() -> void:
	pass # Replace with function body.


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/survivor_game.tscn")
