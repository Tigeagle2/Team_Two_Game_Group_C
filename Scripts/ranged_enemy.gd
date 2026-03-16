extends CharacterBody2D

var speed = 50.0
@onready var nav_agent := $NavigationAgent2D
var knockback_velocity = Vector2.ZERO
var separation_amount: float = 1000.0
var speed_difference: float = 10.0
var off_screen_time: float = 5.0
var attack_buildup_time: float = 1.0
var attack_frequency_min: float = 5.0
var projectile_y_offset: float = 100.0
var attack_rounds: int = 3
var attack_cooldown_random_range: float = 2.0
var current_separation: Vector2 = Vector2.ZERO
var active: bool = false
var on_screen: bool = false
var player: Node2D = null
var setup_active: bool = true
var projectile_attack_active: bool = false
var projectile_scene = preload("res://Scenes/ranged_projectile_enemy.tscn")
var attack_countdown
var screen_countdown
func _ready():
	player = get_tree().get_first_node_in_group("player")
	speed += randf_range(-speed_difference, speed_difference)
	screen_countdown = off_screen_time
	var random_roll = randf_range(0, attack_cooldown_random_range)
	attack_countdown = attack_frequency_min + random_roll
	await get_tree().create_timer(0.1).timeout
	setup_active = false
	
func _process(delta: float) -> void:
	if not on_screen and active:
		if screen_countdown <= 0:
			active = false
		else:
			screen_countdown -= delta
	if attack_countdown <= 0:
		if active and not projectile_attack_active:
			ranged_attack()
	else:
		attack_countdown -= delta
func _physics_process(delta):
	if active:
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
		var final_movement = Vector2.ZERO
		if not projectile_attack_active:
			final_movement = desired_velocity + current_separation
		velocity = final_movement + knockback_velocity
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
func ranged_attack():
	projectile_attack_active = true
	for i in attack_rounds:
		var projectile = projectile_scene.instantiate()
		projectile.setup(attack_buildup_time)
		projectile.global_position.x = self.global_position.x
		projectile.global_position.y = self.global_position.y - (projectile_y_offset)
		get_tree().current_scene.add_child(projectile)
		await get_tree().create_timer(attack_buildup_time).timeout
	projectile_attack_active = false
	var random_roll = randf_range(0, attack_cooldown_random_range)
	attack_countdown = attack_frequency_min + random_roll
	
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true
	active = true
	screen_countdown = off_screen_time

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false
