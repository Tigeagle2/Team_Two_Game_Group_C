extends CharacterBody2D

var speed = 50.0
@onready var nav_agent := $NavigationAgent2D
var knockback_velocity = Vector2.ZERO
var separation_amount: float = 1000.0
var speed_difference: float = 10.0
var current_separation: Vector2 = Vector2.ZERO

var player: Node2D = null
var setup_active: bool = true
func _ready():
	player = get_tree().get_first_node_in_group("player")
	speed += randf_range(-speed_difference, speed_difference)
	await get_tree().create_timer(0.1).timeout
	setup_active = false
func _physics_process(delta):
	# recalculate position every 10 frames
	if player and Engine.get_physics_frames() % 10 == 0:
		nav_agent.target_position = player.global_position

	var next_path_pos = nav_agent.get_next_path_position()
	var move_dir = (next_path_pos - global_position).normalized()
	var desired_velocity = move_dir * speed

	# Only check neighbors every 3 frames
	if Engine.get_physics_frames() % 3 == 0:
		var separation_force = Vector2.ZERO
		for neighbor in $detection_area.get_overlapping_bodies():
			if neighbor != self:
				var diff = global_position - neighbor.global_position
				var d_sq = diff.length_squared()
				if d_sq > 0.1: 
					separation_force += diff / d_sq
		current_separation = separation_force * separation_amount
	velocity = desired_velocity + current_separation
	velocity += knockback_velocity
	knockback_velocity = lerp(knockback_velocity, Vector2.ZERO, 0.1)
	move_and_slide()
func setup(spawn_range_x:int = 20, spawn_range_y: int = 20):
	position.x = randf_range(-spawn_range_x, spawn_range_x)
	position.y = randf_range(-spawn_range_y, spawn_range_y)
	

func _on_hitbox_body_entered(body: Node2D) -> void:
	if setup_active:
		if body.is_in_group("player"):
			position.x += 100
			position.y += 100
