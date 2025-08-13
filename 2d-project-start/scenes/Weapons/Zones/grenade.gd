extends Area2D

var damage = 5
var disabled = false
var triggered = false

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

func _process(delta: float) -> void:
	if not triggered:
		var hit_mobs = $".".get_overlapping_bodies()
		for enemy in hit_mobs:
			if enemy.has_method("take_damage"):
				var damageType = DamageNumbers.DamageTypes.NORMAL
				enemy.take_damage(damage, damageType)
				if not disabled:
					StatusEffects.resetDuration(enemy)
				triggered = true
