extends PlayerBase

var speed = 300
var player_radius_x = 17
var player_radius_y = 17
var is_moving: bool = false
var look_direction: Vector2 = Vector2.RIGHT
func _ready() -> void:
	$hitbox.body_entered.connect(_on_hitbox_body_entered)
	$hitbox.area_entered.connect(_on_hitbox_area_entered)
	super._ready()
func _physics_process(_delta):
	var move_direction = Input.get_vector("west", "east", "north", "south")
	is_moving = move_direction != Vector2.ZERO
	velocity = move_direction * speed 
	move_and_slide()
	
	# Boundary Constraints
	global_position.x = clamp(global_position.x, -1344 + player_radius_x, 1408 - player_radius_x)
	global_position.y = clamp(global_position.y, -896 + player_radius_y, 1056 - player_radius_y)

	# Handle Movement Animations here (based on move_direction)
	if attack_animation_lockout:
		update_other_animations(look_direction)
	elif is_moving:
		update_movement_animations(move_direction)
	else:
		update_other_animations(look_direction)

func _input(event: InputEvent) -> void:
	super._input(event)
	var controller_aim = Input.get_vector("aim_west", "aim_east", "aim_north", "aim_south")
	
	if controller_aim.length() > 0.2:
		look_direction = controller_aim
	elif event is InputEventMouseMotion:
		var mouse_pos = get_global_mouse_position()
		if global_position.distance_to(mouse_pos) > 15:
			look_direction = global_position.direction_to(mouse_pos)
			
	update_weapon_orientation(look_direction)
	# Handle Idle/Aiming animations here (based on look_direction)
	if not is_moving && attack_animation_type == 0 && !attack_animation_lockout:
		update_other_animations(look_direction)

func update_movement_animations(move_dir: Vector2):
	var anim_step = PI / 2
	var anim_index = int(round(move_dir.angle() / anim_step))
	var target_anim = ""
	var animation_speed: float = 2.0

	match anim_index:
		0: target_anim = "run_right"
		1: target_anim = "run_down"
		2, -2: target_anim = "run_left"
		-1: target_anim = "run_up"
	
	if $AnimatedSprite2D.animation != target_anim:
		$AnimatedSprite2D.play(target_anim, animation_speed)

func update_other_animations(look_dir: Vector2):
	var anim_step = PI / 2
	var anim_index = int(round(look_dir.angle() / anim_step))
	var target_anim = ""
	var animation_speed: float = 1.0

	match anim_index:
		0: 
			if attack_animation_type == 0:
				target_anim = "idle_right"
				animation_speed = 1.0
			elif attack_animation_type == 1:
				target_anim = "attack_light_right"
				animation_speed = 6.0
			elif attack_animation_type == 2:
				target_anim = "attack_heavy_right"
				animation_speed = 3.0
		1: 
			if attack_animation_type == 0:
				target_anim = "idle_down"
				animation_speed = 1.0
			elif attack_animation_type == 1:
				target_anim = "attack_light_down"
				animation_speed = 6.0
			elif attack_animation_type == 2:
				target_anim = "attack_heavy_down"
				animation_speed = 3.0
		2, -2: 
			if attack_animation_type == 0:
				target_anim = "idle_left"
				animation_speed = 1.0
			elif attack_animation_type == 1:
				target_anim = "attack_light_left"
				animation_speed = 6.0
			elif attack_animation_type == 2:
				target_anim = "attack_heavy_left"
				animation_speed = 3.0
		-1: 
			if attack_animation_type == 0:
				target_anim = "idle_up"
				animation_speed = 1.0
			elif attack_animation_type == 1:
				target_anim = "attack_light_up"
				animation_speed = 6.0
			elif attack_animation_type == 2:
				target_anim = "attack_heavy_up"
				animation_speed = 3.0
	
	if $AnimatedSprite2D.animation != target_anim:
		$AnimatedSprite2D.play(target_anim, animation_speed)
func update_weapon_orientation(dir: Vector2):
	var weapon_step = PI / 4 
	var weapon_angle = round(dir.angle() / weapon_step) * weapon_step
	$weapons.rotation = weapon_angle

	if cos(weapon_angle) < -0.1:
		$weapons.scale.y = -1
	elif cos(weapon_angle) > 0.1:
		$weapons.scale.y = 1
func _on_attack_play(type: int) -> void:
	if !attack_animation_lockout:
		attack_animation_type = type
		attack_animation_lockout = true
