extends Area2D

var travelled_distance = 0
const SPEED = 1000
const RANGE = 2000
var damage = 5.0
var bounceCount = 3
var currentBounce = 0

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		currentBounce += 1
		var damageType = DamageNumbers.DamageTypes.NORMAL
		body.take_damage(damage, damageType)
		StatusEffects.applyBurn(body)
		rotation = rotation * 90
	if currentBounce > bounceCount:
		queue_free()
