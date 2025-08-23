extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")
@onready var damage_numbers_origin = $DamageNumberOrigins

@export var health = 50.0
@export var hpMult = 1.0

@export var speed = 150.0
@export var speedMult = 1.0

@export var dmgTakenMult = 1.0

@export var damageDealt = 1.0
@export var dmgDealtMult = 1.0

@export var exp_amt: int = 5
@export var expMult = 1.0
@export var orb_spawn_radius: float = 1.0
var defaultSpeed = 100

var character
var canBeStunned = true
var stunCD = 5.0
var stunCD_elapsed = 0.0

const EXP_ORB_SCENE = preload("res://scenes/Systems/Exp_Orb.tscn")

func _ready() -> void:
	defaultSpeed = speed
	health = health*hpMult
	character = get_child(0)
	character.play_walk()

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed * speedMult
	
	stunCD_elapsed += delta
	if stunCD_elapsed >= stunCD:
		canBeStunned = true
	
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
		var death_position = global_position  
		spawn_exp_orb(death_position)
		queue_free()

func spawn_exp_orb(spawn_position: Vector2 = Vector2.ZERO) -> void:
	var orb = EXP_ORB_SCENE.instantiate()
	get_parent().add_child(orb)
	
	# Use provided position or fall back to current global_position
	var base_position = spawn_position if spawn_position != Vector2.ZERO else global_position
	
	# Add small random offset so orbs don't stack perfectly
	var offset = random_offset_in_circle(orb_spawn_radius)
	orb.global_position = base_position + offset
	orb.exp_value = exp_amt * expMult

func random_offset_in_circle(radius: float) -> Vector2:
	var angle := randf() * TAU
	var r := (radius * 0.25) * sqrt(randf())
	return Vector2(cos(angle), sin(angle)) * r


func deal_damage():
	damageDealt * dmgDealtMult
