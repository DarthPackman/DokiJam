extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")
@onready var damage_numbers_origin = $DamageNumberOrigins
@export var health = 50.0
@export var speed = 150.0
var defaultSpeed
@export var dmgTakenMult = 1.0
@export var damageDealt = 1.0
@export var dmgDealtMult = 1.0
var character

func _ready() -> void:
	defaultSpeed = speed
	character = get_child(0)
	character.play_walk()

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	
	if character.has_node("AnimatedSprite2D"):
		if not character.get_node("AnimatedSprite2D").is_playing():
			character.play_walk()
		if direction.x >= 0:
			character.get_node("AnimatedSprite2D").set_flip_h(true)
		elif direction.x <= 0:
			character.get_node("AnimatedSprite2D").set_flip_h(false)
		
	move_and_slide()

func take_damage(damage: float, damageType: DamageNumbers.DamageTypes):
	health -= dmgTakenMult * damage
	DamageNumbers.display_number(dmgTakenMult * damage, damage_numbers_origin.global_position, damageType)
	character.play_hurt()
	if health <= 0:
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		queue_free()

func deal_damage():
	damageDealt * dmgDealtMult
