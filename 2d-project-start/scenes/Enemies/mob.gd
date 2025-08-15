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
@export var orb_spawn_radius: float = 2
@export var defaultSpeed = 100

var character
var canBeStunned = true
var stunCD = 5.0
var stunCD_elapsed = 0.0

const EXP_ORB_SCENE = preload("res://scenes/Systems/Exp_Orb.tscn")

func _ready() -> void:
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
		spawn_exp_orb()
		queue_free()

func spawn_exp_orb() -> void:
	var orb = EXP_ORB_SCENE.instantiate()  
	get_parent().add_child(orb)  
	
	# makes sure it doesn't stack perfectly and spawn in a circle
	var offset = random_offset_in_circle(orb_spawn_radius)  
	orb.global_position = global_position + offset

	orb.exp_value = exp_amt * expMult

func random_offset_in_circle(radius: float) -> Vector2:  
	#  r = R * sqrt(u), theta = 2*pi*v  
	var angle := randf() * TAU  
	var r := radius * sqrt(randf())  
	return Vector2(cos(angle), sin(angle)) * r


func deal_damage():
	damageDealt * dmgDealtMult
