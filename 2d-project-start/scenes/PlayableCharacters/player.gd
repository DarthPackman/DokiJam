extends CharacterBody2D

signal health_depleted
var health = 100.0
var player_speed = 600
var character

func _ready() -> void:
	character = %RegularDragoon

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right", "move_up", "move_down")
	velocity = direction * player_speed
	move_and_slide()
	
	if velocity.length() > 0.0:
		if direction.x == 1:
			character.get_node("AnimatedSprite2D").set_flip_h(true)
		elif direction.x == -1:
			character.get_node("AnimatedSprite2D").set_flip_h(false)
		character.play_walk_animation()
	else:
		character.play_idle_animation()
	
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		for mob in overlapping_mobs:
			if mob.has_method("deal_damage"):
				health -= mob.damageDealt * delta
				%ProgressBar.value = health
		if health <= 0.0:
			health_depleted.emit()
