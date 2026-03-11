extends CharacterBody2D

@export var speed = 150.0
@onready var nav_agent := $NavigationAgent2D

var player: Node2D = null

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	if player:
		nav_agent.target_position = player.global_position
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	var next_path_pos = nav_agent.get_next_path_position()
	var current_pos = global_position
	var new_velocity = (next_path_pos - current_pos).normalized() * speed
	velocity = new_velocity
	move_and_slide()
