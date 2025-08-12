extends Area2D

var travelled_distance = 0
const SPEED = 1000
const RANGE = 1200
var damage = 5.0
var disabled = false

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		var damageType = DamageNumbers.DamageTypes.NORMAL
		body.take_damage(damage, damageType)
		if not disabled:
			StatusEffects.resetDuration(body)
