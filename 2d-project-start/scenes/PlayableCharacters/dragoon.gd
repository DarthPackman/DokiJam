extends Node2D

func play_idle_animation():
	%AnimatedSprite2D.play("idle")
	Autoload.stop_step()

func play_walk_animation():
	%AnimatedSprite2D.play("walk")

func _on_animated_sprite_2d_frame_changed() -> void:
	Autoload.play_step()
