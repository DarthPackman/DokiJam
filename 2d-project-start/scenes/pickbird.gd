extends Control

@onready var regidle = $Panel/MarginContainer/HBoxContainer2/TextureButton/regidle

var playerScene : PackedScene

func _on_selectreg_pressed() -> void:
	playerScene = preload("res://scenes/PlayableCharacters/regular_dragoon.tscn")
	Autoload.set_selected_character_data("Regular", playerScene, "m_r_WingSlap")
	get_tree().change_scene_to_file("res://scenes/survivor_game.tscn")

func _on_selectchonk_pressed() -> void:
	playerScene = preload("res://scenes/PlayableCharacters/chonky_dragoon.tscn")
	Autoload.set_selected_character_data("Chonk", playerScene, "z_ch_StoppyBoots")
	get_tree().change_scene_to_file("res://scenes/survivor_game.tscn")

func _on_selecttall_pressed() -> void:
	playerScene = preload("res://scenes/PlayableCharacters/long_dragoon.tscn")
	Autoload.set_selected_character_data("Long", playerScene,"r_lo_bow")
	get_tree().change_scene_to_file("res://scenes/survivor_game.tscn")

func _on_selectegg_pressed() -> void:
	playerScene = preload("res://scenes/PlayableCharacters/egg_dragoon.tscn")
	Autoload.set_selected_character_data("Egg", playerScene, "a_egg_RottenEgg")
	get_tree().change_scene_to_file("res://scenes/survivor_game.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")

func _on_texture_button_mouse_entered() -> void:
	pass # Replace with function body.

func _on_texture_button_mouse_exited() -> void:
	pass # Replace with function body.

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/survivor_game.tscn")
