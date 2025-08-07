extends Node

func applyPoison(body, damage = 2, interval = 2, duration = 10):
	const POISON = preload("res://scenes/poison.tscn")
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
	
func applyBurn(body, damage = 1, interval = 1, duration = 5):
	const BURN = preload("res://scenes/burn.tscn")
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
	
func applyDaze(body, speedReduction = 50.0, duration = 5):
	const DAZE = preload("res://scenes/daze.tscn")
	if not body.has_node("Daze"):
		var dazeCC = DAZE.instantiate()
		dazeCC.speedReduction = speedReduction
		dazeCC.duration = duration
		body.add_child(dazeCC)
	else:
		var dazeCC = body.get_node("Daze")
		dazeCC.speedReduction = speedReduction
		dazeCC.duration = duration

func applySlow(body, speedReduction = 25.0, duration = 10):
	const SLOW = preload("res://scenes/slow.tscn")
	if not body.has_node("Slow"):
		var slowCC = SLOW.instantiate()
		slowCC.speedReduction = speedReduction
		slowCC.duration = duration
		body.add_child(slowCC)
	else:
		var slowCC = body.get_node("Slow")
		slowCC.speedReduction = speedReduction
		slowCC.duration = duration
		
func applyWeaken(body, damageDecrease = 25.0, duration = 5):
	const WEAKEN = preload("res://scenes/weaken.tscn")
	if not body.has_node("Weaken"):
		var weakenDebuff = WEAKEN.instantiate()
		weakenDebuff.dmgDecrease = damageDecrease
		weakenDebuff.duration = duration
		body.add_child(weakenDebuff)
	else:
		var weakenDebuff = body.get_node("Weaken")
		weakenDebuff.dmgDecrease = damageDecrease
		weakenDebuff.duration = duration

func applyVulnerable(body, damageIncrease = 25.0, duration = 5):
	const VULNERABLE = preload("res://scenes/vulnerable.tscn")
	if not body.has_node("Vulnerable"):
		var vulnerableDebuff = VULNERABLE.instantiate()
		vulnerableDebuff.dmgIncrease = damageIncrease
		vulnerableDebuff.duration = duration
		body.add_child(vulnerableDebuff)
	else:
		var vulnerableDebuff = body.get_node("Vulnerable")
		vulnerableDebuff.dmgIncrease = damageIncrease
		vulnerableDebuff.duration = duration
