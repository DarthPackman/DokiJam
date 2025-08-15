extends Node2D

@onready var hurtSound = $AudioStreamPlayer2D

func play_walk():
	%AnimatedSprite2D.play("walk")

func play_hurt():
	Autoload.robot_hit()
	%AnimatedSprite2D.play("hurt")
