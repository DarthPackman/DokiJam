extends Area2D

var damage = 3
var disabled = false
var duration = 2.5
var duration_elapsed = 0.0
var interval = 0.5

func _ready() -> void:
	$Timer.wait_time = interval
	
func _process(delta: float) -> void:
	if not $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play("duration")
	duration_elapsed += delta
	if duration_elapsed >= duration:
		queue_free()

func _on_timer_timeout() -> void:
	var hit_mobs = get_overlapping_bodies()
	for enemy in hit_mobs:
		if enemy.has_method("take_damage"):
			var damageType = DamageNumbers.DamageTypes.NORMAL
			enemy.take_damage(damage, damageType)
			if not disabled:
				StatusEffects.applySlow(enemy)
