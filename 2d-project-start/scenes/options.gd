extends Control

@onready var asp = $AudioStreamPlayer

var volume = 0

func _ready():
	AudioServer.set_bus_volume_db(0,volume)

func _on_backbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")


func _on_volumeslider_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)
