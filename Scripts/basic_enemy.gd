extends CharacterBody2D

@export var speed = 250.0
@onready var nav_agent := $NavigationAgent2D
var random_spawn_range_x = 20.0
var random_spawn_range_y = 20.0

var player: Node2D = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	position.x = randf_range(-random_spawn_range_x, random_spawn_range_x)
	position.y = randf_range(-random_spawn_range_y, random_spawn_range_y)

func _physics_process(_delta):
	if player:
		nav_agent.target_position = player.global_position
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	var next_path_pos = nav_agent.get_next_path_position()
	var current_pos = global_position
	var new_velocity = (next_path_pos - current_pos).normalized() * speed
	nav_agent.set_velocity(new_velocity)
	


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
