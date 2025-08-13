extends Area2D

var damage = 5
var disabled = false
var interval = 0.25

func _ready() -> void:
	$Timer.wait_time = interval
	push_warning("Grenade")
	$AnimatedSprite2D.play("default")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	var hit_mobs = $".".get_overlapping_bodies()
	for enemy in hit_mobs:
		if enemy.has_method("take_damage"):
			var damageType = DamageNumbers.DamageTypes.NORMAL
			enemy.take_damage(damage, damageType)
			if not disabled:
				StatusEffects.resetDuration(enemy)
