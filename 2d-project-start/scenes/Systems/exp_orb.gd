extends Area2D

@export var exp_value: int = 10
@export var collection_radius: float = 80.0
@export var fly_speed: float = 150.0

var player: Node2D
var is_flying_to_player: bool = false

@onready var collision = $CollisionShape2D

func _ready() -> void:
	# Connect the area entered signal
	body_entered.connect(_on_body_entered)
	
	# Find the player
	player = get_node("/root/Game/Player")
	
	# Set up the orb appearance (you can customize this)
	modulate = Color.CYAN
	
	# Optional: Add a gentle float animation
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "position:y", position.y - 5, 1.0)
	tween.tween_property(self, "position:y", position.y + 5, 1.0)

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
	if body.name == "Player":
		collect()

func collect() -> void:
	if player and player.has_method("collect_exp_orb"):
		player.collect_exp_orb(exp_value)
	
	# Optional: Add collection effect
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.2)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free)
