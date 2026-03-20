extends PlayerBase

var speed = 250
var player_direction = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$hitbox.body_entered.connect(_on_hitbox_body_entered)
	$hitbox.area_entered.connect(_on_hitbox_area_entered)
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)

func _physics_process(_delta):
	var direction = Input.get_vector("west", "east", "north", "south")
	velocity = direction * speed 
	move_and_slide()
	var look_direction = Vector2.ZERO
	var controller_aim = Input.get_vector("aim_west", "aim_east", "aim_north", "aim_south")
	if controller_aim.length() > 0.2:
		look_direction = controller_aim
	else:
		var mouse_pos = get_global_mouse_position()
		if global_position.distance_to(mouse_pos) > 15:
			look_direction = global_position.direction_to(mouse_pos)
	if look_direction != Vector2.ZERO:
		update_weapon_orientation(look_direction)

func update_weapon_orientation(dir: Vector2):
	var angle_step = PI / 4 
	var snapped_angle = round(dir.angle() / angle_step) * angle_step
	$weapons.rotation = snapped_angle
	if cos(snapped_angle) < -0.1:
		$weapons.scale.y = -1
		$Sprite2D.flip_h = true
	elif cos(snapped_angle) > 0.1:
		$weapons.scale.y = 1
		$Sprite2D.flip_h = false
		$weapons.scale.y = 1
