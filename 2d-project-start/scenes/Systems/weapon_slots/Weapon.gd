#class_name Weapon  
#extends Resource  
  #
#@export var name: String = "Weapon"  
#@export var level: int = 1  
#@export var placeholder_color: Color = Color(0.3, 0.6, 0.9, 1.0)  
#@export var texture: Texture2D

# weapon.gd
extends Control

@export var default_weapon_scene: PackedScene 

func _ready() -> void:
	if has_node("Icon"):
		var icon := $Icon
		icon.self_modulate = Color(1, 1, 1, 1)

func get_drag_data(at_position: Vector2) -> Variant:
	var preview := duplicate(DUPLICATE_USE_INSTANTIATION | DUPLICATE_SCRIPTS)
	set_drag_preview(preview)
	return {
		"type": "weapon",
		"scene": default_weapon_scene,
		"source": self
	}
