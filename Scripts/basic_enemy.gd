extends CharacterBody2D

var speed = 125.0
@onready var nav_agent := $NavigationAgent2D
var knockback_velocity = Vector2.ZERO
var separation_amount: float = 1000.0
var speed_difference: float = 10.0
var off_screen_time: float = 3.0
var current_separation: Vector2 = Vector2.ZERO
var active: bool = false
var on_screen: bool = false
var player: Node2D = null
var setup_active: bool = true
var dead: bool = false
var damage: int = 10
var health: int = 100
var screen_countdown
var death_sound = preload("res://Assets/Sound_Effects/Enemy_Grunt_1.mp3")
var flashbang_active: bool = false
var flashbang_cooldown: float = 5.0
var flashbang_countdown
var dead_backup_counter: float = 5
func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.get_node("weapons").get_node("special_weapon").special_weapon_activated.connect(_on_special_weapon_activated)
	speed += randf_range(-speed_difference, speed_difference)
	await get_tree().create_timer(0.1, false).timeout
	setup_active = false
	screen_countdown = off_screen_time
func _process(delta: float) -> void:
	if not on_screen and active:
		if screen_countdown <= 0:
			active = false
		else:
			screen_countdown -= delta
	if flashbang_active:
		active = false
		flashbang_countdown -= delta
		if flashbang_countdown <= 0:
			flashbang_active = false
			$CollisionShape2D.set_deferred("disabled", true)
			if on_screen:
				active = true
	if dead:
		dead_backup_counter -= delta
		if dead_backup_counter <= 0:
			queue_free()
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
		velocity = desired_velocity + current_separation
		velocity += knockback_velocity
		knockback_velocity = lerp(knockback_velocity, Vector2.ZERO, 0.1)
		move_and_slide()
	else:
		velocity = knockback_velocity
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


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true
	active = true
	screen_countdown = off_screen_time

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false
func _on_hitbox_area_entered(area: Area2D) -> void:
	if !setup_active:
		if area.is_in_group("weapon_heavy"):
			take_knockback(player.heavy_weapon.knockback_strength)
			take_damage(player.heavy_weapon.damage)
		if area.is_in_group("weapon_light"):
			take_knockback(player.light_weapon.knockback_strength)
			take_damage(player.light_weapon.damage)
func take_damage(self_damage: int):
	health -= self_damage
	if health <= 0 && not dead:
		dead = true
		gamemanager.special_charge += 0.5
		gamemanager.score += 10
		audiomanager.play_sound_effect(death_sound, global_position)
		queue_free()
func take_knockback(amount: int):
	var push_direction = (self.global_position - player.global_position).normalized()
	knockback_velocity = push_direction * amount
func _on_special_weapon_activated():
	if on_screen:
		flashbang_active = true
		velocity = Vector2(0, 0)
		$CollisionShape2D.set_deferred("disabled", true)
		flashbang_countdown = flashbang_cooldown
		take_damage(5)
