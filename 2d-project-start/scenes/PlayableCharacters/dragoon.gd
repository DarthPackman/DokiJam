extends Node2D

func play_idle_animation():
	%AnimatedSprite2D.play("idle")
	Autoload.stop_step()

func play_walk_animation():
	%AnimatedSprite2D.play("walk")
	Autoload.play_step()
