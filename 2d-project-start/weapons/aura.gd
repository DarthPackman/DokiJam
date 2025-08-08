extends Area2D

var damage = 5.0
var damage_interval = 1.0 # seconds

var bodies_in_aura := []

@onready var damage_timer := Timer.new()

func _ready():
	# Set up the timer
	damage_timer.wait_time = damage_interval
	damage_timer.autostart = true
	damage_timer.timeout.connect(_on_damage_timer_timeout)
	add_child(damage_timer)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		if not bodies_in_aura.has(body):
			bodies_in_aura.append(body)
			# Optionally, apply damage immediately on entry:
			var damageType = DamageNumbers.DamageTypes.NORMAL
			body.take_damage(damage, damageType)
			StatusEffects.resetDuration(body)

func _on_body_exited(body: Node2D) -> void:
	if bodies_in_aura.has(body):
		bodies_in_aura.erase(body)

func _on_damage_timer_timeout():
	for body in bodies_in_aura:
		if body and body.has_method("take_damage"):
			var damageType = DamageNumbers.DamageTypes.NORMAL
			body.take_damage(damage, damageType)
			StatusEffects.resetDuration(body)
