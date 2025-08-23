extends Area2D

@export var exp_value: int = 10
@export var collection_radius: float = 150.0
@export var fly_speed: float = 300.0

var player: CharacterBody2D
var is_flying_to_player: bool = false

@onready var collision = $CollisionShape2D

func _ready() -> void:
	# Connect the area entered signal
	body_entered.connect(_on_body_entered)
	
	# Find the player
	player = get_tree().get_first_node_in_group("Player")
	
	# Set up the orb appearance (you can customize this)
	modulate = Color.CYAN
	
func _physics_process(delta: float) -> void:
	if not player:
		return
		
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# Start flying to player when within collection radius
	if distance_to_player <= collection_radius and not is_flying_to_player:
		is_flying_to_player = true
		
	# Fly towards player
	if is_flying_to_player:
		var direction = global_position.direction_to(player.global_position)
		global_position += direction * fly_speed * delta
		
		# Collect when very close
		if distance_to_player <= 10.0:
			collect()

func _on_body_entered(body: Node2D) -> void:
	# This is still here for cases where the player physically touches the orb
	# before the "flying" logic is triggered.
	if body.name == "Player":
		collect()

func collect() -> void:
	if player and player.has_method("collect_exp_orb"):
		player.collect_exp_orb(exp_value)
		queue_free()
