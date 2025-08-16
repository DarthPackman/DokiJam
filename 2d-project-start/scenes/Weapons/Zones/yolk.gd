extends Area2D

var damage = 2.5
var disabled = false
var duration = 1.0
var duration_elapsed = 0.0
var interval = 0.99
var triggered = false

func _ready() -> void:
	$Timer.wait_time = interval
	var hit_mobs = $".".get_overlapping_bodies()
	for enemy in hit_mobs:
		if enemy.has_method("take_damage"):
			var damageType = DamageNumbers.DamageTypes.NORMAL
			enemy.take_damage(damage, damageType)
			if not disabled:
				StatusEffects.applyBurn(enemy)
	
func _process(delta: float) -> void:
	duration_elapsed += delta
	if duration_elapsed >= duration:
		queue_free()
	if not triggered:
		var hit_mobs = $".".get_overlapping_bodies()
		for enemy in hit_mobs:
			if enemy.has_method("take_damage"):
				var damageType = DamageNumbers.DamageTypes.NORMAL
				enemy.take_damage(damage, damageType)
				if not disabled:
					StatusEffects.applyBurn(enemy)
				triggered = true

func _on_timer_timeout() -> void:
	var hit_mobs = $".".get_overlapping_bodies()
	for enemy in hit_mobs:
		if enemy.has_method("take_damage"):
			var damageType = DamageNumbers.DamageTypes.NORMAL
			enemy.take_damage(damage, damageType)
			if not disabled:
				StatusEffects.applyBurn(enemy)
