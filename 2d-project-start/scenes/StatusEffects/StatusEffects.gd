extends Node

func applyPoison(body, damage = 2, interval = 1, duration_time_elapse = 0.0, duration = 5):
	const POISON = preload("res://scenes/StatusEffects/poison.tscn")
	if not body.has_node("Poison"):
		var poisonDOT = POISON.instantiate()
		poisonDOT.damage = damage
		poisonDOT.interval = interval
		poisonDOT.duration = duration
		body.add_child(poisonDOT)
	else:
		var poisonDOT = body.get_node("Poison")
		poisonDOT.damage = damage
		poisonDOT.interval = interval
		poisonDOT.duration = duration
	
	if body.has_node("Daze"):
		detonateEffect(body.get_node("Daze"))
	if body.has_node("Slow"):
		detonateEffect(body.get_node("Slow"))
	if body.has_node("Weaken"):
		spreadEffect(body.get_node("Weaken"))
	if body.has_node("Vulnerable"):
		spreadEffect(body.get_node("Vulnerable"))
	
func applyBurn(body, damage = 1, interval = 0.5, duration = 5):
	const BURN = preload("res://scenes/StatusEffects/burn.tscn")
	if not body.has_node("Burn"):
		var burnDOT = BURN.instantiate()
		burnDOT.damage = damage
		burnDOT.interval = interval
		burnDOT.duration = duration
		body.add_child(burnDOT)
	else:
		var burnDOT = body.get_node("Burn")
		burnDOT.damage = damage
		burnDOT.interval = interval
		burnDOT.duration = duration
	
	if body.has_node("Daze"):
		detonateEffect(body.get_node("Daze"))
	if body.has_node("Slow"):
		detonateEffect(body.get_node("Slow"))
	if body.has_node("Weaken"):
		spreadEffect(body.get_node("Weaken"))
	if body.has_node("Vulnerable"):
		spreadEffect(body.get_node("Vulnerable"))
	
func applyDaze(body, speedReduction = 50.0, duration = 5):
	const DAZE = preload("res://scenes/StatusEffects/daze.tscn")
	if not body.has_node("Daze"):
		var dazeCC = DAZE.instantiate()
		dazeCC.speedReduction = speedReduction
		dazeCC.duration = duration
		body.add_child(dazeCC)
	else:
		var dazeCC = body.get_node("Daze")
		dazeCC.speedReduction = speedReduction
		dazeCC.duration = duration
	
	if body.has_node("Poison"):
		detonateEffect(body.get_node("Poison"))
	if body.has_node("Burn"):
		detonateEffect(body.get_node("Burn"))
	if body.has_node("Weaken"):
		enhanceEffect(body.get_node("Weaken"))
	if body.has_node("Vulnerable"):
		enhanceEffect(body.get_node("Vulnerable"))

func applySlow(body, speedReduction = 35.0, duration = 5):
	const SLOW = preload("res://scenes/StatusEffects/slow.tscn")
	if not body.has_node("Slow"):
		var slowCC = SLOW.instantiate()
		slowCC.speedReduction = speedReduction
		slowCC.duration = duration
		body.add_child(slowCC)
	else:
		var slowCC = body.get_node("Slow")
		slowCC.speedReduction = speedReduction
		slowCC.duration = duration
	if body.has_node("Poison"):
		detonateEffect(body.get_node("Poison"))
	if body.has_node("Burn"):
		detonateEffect(body.get_node("Burn"))
	if body.has_node("Weaken"):
		enhanceEffect(body.get_node("Weaken"))
	if body.has_node("Vulnerable"):
		enhanceEffect(body.get_node("Vulnerable"))
		
func applyWeaken(body, damageDecrease = 25.0, duration = 5):
	const WEAKEN = preload("res://scenes/StatusEffects/weaken.tscn")
	if not body.has_node("Weaken"):
		var weakenDebuff = WEAKEN.instantiate()
		weakenDebuff.dmgDecrease = damageDecrease
		weakenDebuff.duration = duration
		body.add_child(weakenDebuff)
	else:
		var weakenDebuff = body.get_node("Weaken")
		weakenDebuff.dmgDecrease = damageDecrease
		weakenDebuff.duration = duration
	
	if body.has_node("Daze"):
		enhanceEffect(body.get_node("Daze"))
	if body.has_node("Slow"):
		enhanceEffect(body.get_node("Slow"))
	if body.has_node("Burn"):
		spreadEffect(body.get_node("Burn"))
	if body.has_node("Poison"):
		spreadEffect(body.get_node("Poison"))

func applyVulnerable(body, damageIncrease = 25.0, duration = 5):
	const VULNERABLE = preload("res://scenes/StatusEffects/vulnerable.tscn")
	if not body.has_node("Vulnerable"):
		var vulnerableDebuff = VULNERABLE.instantiate()
		vulnerableDebuff.dmgIncrease = damageIncrease
		vulnerableDebuff.duration = duration
		body.add_child(vulnerableDebuff)
	else:
		var vulnerableDebuff = body.get_node("Vulnerable")
		vulnerableDebuff.dmgIncrease = damageIncrease
		vulnerableDebuff.duration = duration
	
	if body.has_node("Daze"):
		enhanceEffect(body.get_node("Daze"))
	if body.has_node("Slow"):
		enhanceEffect(body.get_node("Slow"))
	if body.has_node("Burn"):
		spreadEffect(body.get_node("Burn"))
	if body.has_node("Poison"):
		spreadEffect(body.get_node("Poison"))

func applyStun(body, duration = 1):
	const STUN = preload("res://scenes/StatusEffects/stun.tscn")
	if not body.has_node("Stun"):
		var stunCC = STUN.instantiate()
		stunCC.duration = duration
		body.add_child(stunCC)
	else:
		var stunCC = body.get_node("Stun")
		stunCC.duration = duration

func resetDuration(body):
	if body.has_node("Daze"):
		body.get_node("Daze").duration_time_elapsed = 0.0
	if body.has_node("Slow"):
		body.get_node("Slow").duration_time_elapsed = 0.0
	if body.has_node("Weaken"):
		body.get_node("Weaken").duration_time_elapsed = 0.0
	if body.has_node("Vulnerable"):
		body.get_node("Vulnerable").duration_time_elapsed = 0.0
	if body.has_node("Burn"):
		body.get_node("Burn").duration_time_elapsed = 0.0
	if body.has_node("Poison"):
		body.get_node("Poison").duration_time_elapsed = 0.0
	
func spreadEffect(spread):
	spread.spread_effect()

func enhanceEffect(enhance):
	enhance.enhance_effect()

func detonateEffect(detonate):
	detonate.detonate_effect()
