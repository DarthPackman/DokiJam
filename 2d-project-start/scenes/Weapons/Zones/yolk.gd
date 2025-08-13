extends Area2D

var damage = 5
var disabled = false
var duration = 5.0
var duration_elapsed = 0.0
var interval = 0.5

func _ready() -> void:
	$Timer.wait_time = interval
	
func _process(delta: float) -> void:
	duration_elapsed += delta
	if duration_elapsed >= duration:
		queue_free()

func _on_timer_timeout() -> void:
	var hit_mobs = $".".get_overlapping_bodies()
	for enemy in hit_mobs:
		if enemy.has_method("take_damage"):
			var damageType = DamageNumbers.DamageTypes.NORMAL
			enemy.take_damage(damage, damageType)
			if not disabled:
				StatusEffects.applyBurn(enemy)
