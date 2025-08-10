extends Area2D

var damage = 5.0

func hit():
	var hit_mobs = $".".get_overlapping_bodies()
	for enemy in hit_mobs:
		if enemy.has_method("take_damage"):
			var damageType = DamageNumbers.DamageTypes.NORMAL
			enemy.take_damage(damage, damageType)
			StatusEffects.applyWeaken(enemy)
