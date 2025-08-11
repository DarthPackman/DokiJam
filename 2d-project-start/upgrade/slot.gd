extends PanelContainer

@export var weapon: Weapon:
		set(value):
			weapon = value
			$TextureRect.texture = value.texture
			$Cooldown.wait_time = value.cooldown

func _on_cooldown_timeout() -> void:
	pass # Replace with function body.
