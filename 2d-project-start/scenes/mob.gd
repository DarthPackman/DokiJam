extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")
@onready var damage_numbers_origin = $DamageNumberOrigins
@export var health = 50.0
@export var speed = 150.0
@export var dmgTakenMult = 1.0
@export var damageDealt = 1.0
@export var dmgDealtMult = 1.0

func _ready() -> void:
	%Slime.play_walk()

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()

func take_damage(damage: float, damageType: DamageNumbers.DamageTypes):
	health -= dmgTakenMult * damage
	DamageNumbers.display_number(dmgTakenMult * damage, damage_numbers_origin.global_position, damageType)
	%Slime.play_hurt()
	if health <= 0:
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		queue_free()

func deal_damage():
	damageDealt * dmgDealtMult
