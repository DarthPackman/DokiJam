extends Node2D

func play_idle_animation():
	%AnimatedSprite2D.play("idle")

func play_walk_animation():
	%AnimatedSprite2D.play("walk")

func _on_animated_sprite_2d_frame_changed() -> void:
	if %AnimatedSprite2D.get_animation() == "walk":
		Autoload.play_step()
