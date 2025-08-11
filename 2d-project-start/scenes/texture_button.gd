extends TextureButton

@onready var animated_sprite = $AnimatedSprite2D # Adjust path if needed

func _ready():
	# Play the default animation when the button is ready
	animated_sprite.play("default_anim") 

func _on_mouse_entered():
	animated_sprite.play("hover_anim")

func _on_mouse_exited():
	animated_sprite.play("default_anim") # Or animated_sprite.stop()
